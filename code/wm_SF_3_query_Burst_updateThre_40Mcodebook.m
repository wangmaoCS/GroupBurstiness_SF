
%addpath('./code_burst/');
addpath('./utilize/');

query_dir = '/run/media/401/DataBackup/public_data/SF/PCI_image/feature/query/';

%load query data
knn     = 5;
q_ndes  = load_ext([query_dir 'query_feature_nsift.uint32']);
q_cndes = [0 cumsum(double(q_ndes))];  %1*n_image
q_X     = load_ext([query_dir 'query_feature_sift.uint8'],128);
q_vw    = load_ext(['../data/' 'SF_dbvw_40Mcodebook_q.int32'],knn);

query_num = length(q_ndes);

load('../ivf_data_200M_40Mcodebook/SF_ivf_infor.mat');
image_num = length(imnorms);

% compute the descid_to_imgid
descid_to_imgid = load_ext('../ivf_data_200M_40Mcodebook/SF_descid_to_imgid.int32');
descid_to_imgid = descid_to_imgid';

% load Pitts data inverted index file
fivf_name = '../ivf_data_200M_40Mcodebook/SF_ivf';
fprintf ('* Load the inverted file from %s\n', fivf_name);
ivfhe = yael_ivf_he (fivf_name);
ivfhe.verbose = false; 

%% step3 :  Query in HE invert index
ht = 24;             % Hamming Embedding threshold
nbits = 64;
scoremap = zeros (1, nbits+1);       % How we map Hamming distances to scores
sigma = 16;
scoremap(1:ht+1) = exp(-((0:ht)/sigma) .^2 );

%match_set = cell(1000,query_num);
rank = 1000;
result_list = zeros(rank,query_num);

tic
for k1 = 1:query_num

    match_set = cell(1000,1);
    
    n_imscores = zeros(knn,image_num);
    matches_ma = [];
    m_imids_ma = [];

    qvtest = q_X(:,q_cndes(k1)+1:q_cndes(k1+1) );                    
    
    % sift to rootsift
    qvtest = single(qvtest);
    for k2 = 1:size(qvtest,2)
        tmp_v = single(qvtest(:,k2)) / sum(qvtest(:,k2));
        qvtest(:,k2) = sqrt(tmp_v);
    end
    
    n_feat = size(qvtest,2);
    
    for k2 = 1:knn       
        qvwtest = q_vw(k2, q_cndes(k1)+1:q_cndes(k1+1));
        matches = ivfhe.query(ivfhe,int32(1:size(qvtest,2)),qvtest,ht,qvwtest);

        m_imids = descid_to_imgid(matches(2,:));
        n_immatches = hist (m_imids, 1:image_num);
                    
        idf_score = idf_data(qvwtest(matches(1,:))) .^ 2;        
        idf_scoremap = scoremap (matches(3,:)+1) .* idf_score;
        idf_scoremap_bst = BurstWeighten(matches(1,:),m_imids,double(q_ndes(k1)),idf_scoremap);
        n_imscores(k2,:) = accumarray (m_imids, idf_scoremap_bst', [image_num 1]) ./ (imnorms+0.00001);
             
        matches(1,:) = matches(1,:) + (k2-1) * n_feat;       
        matches_ma = [matches_ma matches];            
        m_imids_ma = [m_imids_ma m_imids'];
    end 
    

    % Images are ordered by descreasing score                 
    n_imscores_sum = sum(n_imscores,1);
    %n_imscores_sum = n_imscores;
    [~, idx] = sort (n_imscores_sum, 'descend');
    result_list(:,k1) = idx(1:rank);

    n_count = 0;
    for k3 = 1:1000
        curr_match_set = matches_ma(:,m_imids_ma == idx(k3));
        curr_match_set(2,:) = curr_match_set(2,:) - imgid_to_descid(idx(k3));
        match_set{k3}    = curr_match_set;
        n_count = n_count + size(curr_match_set,2);
    end                            
    
    save(sprintf('result_updateThre_40Mcodebook/matches_burst/matches_%03d.mat',k1),'match_set');
    disp(k1);
end
toc

save(sprintf('result_updateThre_40Mcodebook/result_list_top1000_%d_knn5_burst.mat',ht),'result_list');

%Elapsed time is 6817.673852 seconds.
%Elapsed time is 6754.065863 seconds.

%update threshold with 200M features
%Elapsed time is 5368.271163 seconds.

%update threshold with 200M features + 40M codebook
%Elapsed time is 5877.545982 seconds.