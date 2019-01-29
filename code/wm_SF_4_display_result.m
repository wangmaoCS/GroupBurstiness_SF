% feature path
% feat_dir = '/run/media/401/DataBackup/public_data/SF/PCI_image/feature/feature/';
% sub_dir  = struct2cell(dir([feat_dir 'PCI*']));
% sub_dir  = sub_dir(1,:);

% %load vw file to compute the idf information
% num_db  = 0;
% for k1 = 1: length(sub_dir)
%     cur_dir = [feat_dir sub_dir{k1}];
%     cur_fname = struct2cell(dir([cur_dir '/*.mat'] ));
%     cur_fname = cur_fname(1,:);  
%     
%     for k2 = 1:length(cur_fname)
%        load( fullfile(cur_dir,cur_fname{k2}));
%        num_db  = num_db + length(dbImageFns);       
%        disp(k2);
%     end       
% end
% 
% dbImageFnsIndex = zeros(num_db,3);
% idx = 0;
% sub_FeatFns = cell(length(sub_dir),1);
% for k1 = 1: length(sub_dir)
%     cur_dir = [feat_dir sub_dir{k1}];
%     cur_fname = struct2cell(dir([cur_dir '/*.mat'] ));
%     cur_fname = cur_fname(1,:);  
%     
%     sub_FeatFns{k1} = cur_fname;
%     
%     for k2 = 1:length(cur_fname)
%        load( fullfile(cur_dir,cur_fname{k2}));
%        tmp_ImageNum = length(dbImageFns);
%        
%        dbImageFnsIndex(idx+1:idx+tmp_ImageNum,1) = k1;  % directory
%        dbImageFnsIndex(idx+1:idx+tmp_ImageNum,2) = k2;  % fname
%        dbImageFnsIndex(idx+1:idx+tmp_ImageNum,3) = 1:tmp_ImageNum; % index
%        idx = idx + tmp_ImageNum;
%        disp(k2);
%     end       
% end
% 
% save('dbImageIndexInfor.mat','dbImageFnsIndex','sub_FeatFns','sub_dir');

qPath  = '/run/media/401/DataBackup/public_data/SF/sf/BuildingQueryImagesCartoIDCorrected-Upright/';
dbPath = '/run/media/401/DataBackup/public_data/SF/PCI_image/img/';

feat_dir = '/run/media/401/DataBackup/public_data/SF/PCI_image/feature/';

% load query fname
feature_path_q = [feat_dir 'query/'];
load([feature_path_q 'query_feature_fname']); 
qImageFns  = dbImageFns;

% load database fname information
%load('./result/dbImageIndexInfor.mat','dbImageFnsIndex','sub_FeatFns','sub_dir');
load('./result/SF_dbImageFns.mat','SF_dbImageFns');

%load inital query result 
load('./result/result_list_top1000_24_knn5_updateIDF.mat');

%load geom information
feature_path_db = './result/';
geom_db   = load_ext([feature_path_db 'SF_dbGeom.float'],5);
nsift_db  = load_ext([feature_path_db 'SF_dbnsift.uint32']);
cndes_db  = [0 cumsum(double(nsift_db))];

geom_q    = load_ext([feature_path_q 'query_feature_geom.float'],5);
nsift_q   = load_ext([feature_path_q 'query_feature_nsift.uint32']);
cndes_q   = [0 cumsum(double(nsift_q))];

num_query = length(qImageFns);
rank = 1000;

for k1 = 1:num_query
    q_fname = qImageFns{k1};
    q_fname = [q_fname(1:end-15) 'jpg'];
    q_im    = imread([qPath q_fname]);    
    q_feat  = geom_q(:,cndes_q(k1)+1:cndes_q(k1+1));
    
    %load(sprintf('./result/matches/matches_%03d.mat',k1));
    %load(sprintf('./result/matches_burst/matches_%03d.mat',k1));
    %load(sprintf('./result_updateThre/matches_burst_sp/match_spTop1000_%05d.mat',k1));
    load(sprintf('./result_updateThre_40Mcodebook/matches_burst/matches_%03d.mat',k1));
    %match_set = match_sp;
    
    for k2 = 1:10
        db_idx   = result_list(k2,k1);      
        db_fname = SF_dbImageFns{db_idx};
        db_im = imread([dbPath db_fname]);       
        db_feat  = geom_db(:,cndes_db(db_idx)+1:cndes_db(db_idx+1));

        match_idx = match_set{k2}(1:2,:);
        match_idx(1,:) = mod(match_idx(1,:),int32(nsift_q(k1)));
        match_idx(1,match_idx(1,:) == 0) = nsift_q(k1);
        
        if size(match_idx,2) > 1000
            continue;
        end
        disp_match_features_hesaff(q_im,db_im,q_feat,db_feat,match_idx,'r');
       
       fprintf('query: %d, database: %d\n', k1,k2);
    end
end
