% load projection and threshold data
load('../codebook_data/projection_data_root_SF_200M_40Mcodebook.mat','Q','threshold');

% load centroids file
load('../codebook_data/codebook_SF_200k_rootsift_40M.mat','codebook');
num_codebook = size(codebook,2);

% feature path
feat_dir = '/run/media/401/DataBackup/public_data/SF/PCI_image/feature/db/';
sub_dir  = struct2cell(dir([feat_dir 'PCI*']));
sub_dir  = sub_dir(1,:);

%load vw, nsift and sift information to compute num_db and num_des
nbits   = 64;

%load nsift 
db_path  = './result/';
num_des  = load_ext([db_path 'SF_dbnsift.uint32']);
num_db   = length(num_des);
fprintf('SF has %d images, and %d sift features\n', num_db, sum(num_des)); %677448545

%load vw data
vw = load_ext('../data/SF_dbvw_40Mcodebook.int32');

%load idf
load('../data/SF_idf_40Mcodebook_maxIDF.mat','idf_data');


%build initial invert index file   
for k1 = 1: 1
    cur_dir = [feat_dir sub_dir{k1}];      
    
    cur_sift_fname = struct2cell(dir([cur_dir '/*.uint8'] ));
    cur_sift_fname = cur_sift_fname(1,:);                 
end
    
tmp_sift  = load_ext( fullfile(cur_dir,cur_sift_fname{1}),128,1000 );      
v     = tmp_sift;
idx   = vw(1:1000);
ivfhe = yael_ivf_he (num_codebook, nbits, single(v), @yael_kmeans, codebook, idx);
ivfhe.medians = single( threshold );
ivfhe.Q = Q;

%build final invert index file
descid_to_imgid = zeros (sum(num_des), 1);  % desc to image conversion
imgid_to_descid = zeros (num_db, 1);      % for finding desc id
imnorms = zeros(num_db,1);
lastid = 0;

index = 1;
image_idx = 0;
vw_idx = 0;

for k1 = 1: length(sub_dir)
    cur_dir = [feat_dir sub_dir{k1}];           
            
    cur_nsift_fname = struct2cell(dir([cur_dir '/*.uint32'] ));
    cur_nsift_fname = cur_nsift_fname(1,:);
    
    cur_sift_fname = struct2cell(dir([cur_dir '/*.uint8'] ));
    cur_sift_fname = cur_sift_fname(1,:);    
    
    for k2 = 1:length(cur_sift_fname)            
       tmp_nsift = load_ext( fullfile(cur_dir,cur_nsift_fname{k2}) );
       tmp_sift  = load_ext( fullfile(cur_dir,cur_sift_fname{k2}),128 );

       cndes = [0 cumsum(tmp_nsift)];
       
       %add entry into the invert index file           
       for k3 = 1:length(tmp_nsift);
          image_idx = image_idx + 1; 
          
          vtest = single(tmp_sift(:,cndes(k3)+1:cndes(k3+1))) ;                
          for k4 = 1:size(vtest,2)
               tmp_v = single(vtest(:,k4)) / sum(vtest(:,k4));
               vtest(:,k4) = sqrt(tmp_v);
          end
          
          %vwtest = tmp_vw(cndes(k3)+1:cndes(k3+1));
          %[tmp_vwtest,~]  = yael_nn(codebook,vtest);
          vwtest = vw(vw_idx+1:vw_idx+num_des(image_idx));
          vw_idx = vw_idx + num_des(image_idx);
          
          [~, codes] = ivfhe.add (ivfhe, lastid+(1:tmp_nsift(k3)), double(vtest), vwtest);
          tmp_hist = hist(vwtest,1:num_codebook);
          imnorms(image_idx) = norm(tmp_hist .* idf_data);

          descid_to_imgid(lastid+(1:tmp_nsift(k3))) = image_idx;
          imgid_to_descid(image_idx) = lastid;
          lastid = lastid + tmp_nsift(k3);
          if round(image_idx / 100 ) == (image_idx /100)
               disp(image_idx);
          end       

       end
       
       disp(index);
       index = index + 1;
       
    end      
end

ivf_fname = '../ivf_data_200M_40Mcodebook/SF_ivf';
ivfhe.save(ivfhe,ivf_fname);
 
save('../ivf_data_200M_40Mcodebook/SF_ivf_infor.mat','imnorms','imgid_to_descid','idf_data');
save_ext('../ivf_data_200M_40Mcodebook/SF_descid_to_imgid.int32',descid_to_imgid);