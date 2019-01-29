%feature path
feat_dir = '/run/media/401/DataBackup/public_data/SF/PCI_image/feature/db/';
sub_dir  = struct2cell(dir([feat_dir 'PCI*']));
sub_dir  = sub_dir(1,:);

%% part1
%load vw file to compute the idf information
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
% SF_dbImageFns = cell(num_db,1);
% idx = 0;
% post_len = length('.ppm.hesaff.sift');
% for k1 = 1: length(sub_dir)
%     cur_dir = [feat_dir sub_dir{k1}];
%     cur_fname = struct2cell(dir([cur_dir '/*.mat'] ));
%     cur_fname = cur_fname(1,:);          
%     
%     for k2 = 1:length(cur_fname)
%        load( fullfile(cur_dir,cur_fname{k2}));
%        tmp_ImageNum = length(dbImageFns);
%        
%        dir_path = cur_fname{k2}(6:end-10);
%        for k3 = 1:tmp_ImageNum
%         SF_dbImageFns{idx+k3} = [dir_path '/' dbImageFns{k3}(1:end-post_len) '.jpg'];
%        end
%        
%        idx = idx + tmp_ImageNum;
%        disp(k2);
%     end       
% end
% save('./result/SF_dbImageFns.mat','SF_dbImageFns');

%% part2
% load('./result/SF_dbImageFns.mat','SF_dbImageFns');
% num_db = length(SF_dbImageFns);
% 
% SF_dbnsift    = zeros(num_db,1);
% idx = 0;
% for k1 = 1: length(sub_dir)
%     cur_dir = [feat_dir sub_dir{k1}];
%     cur_nsift = struct2cell(dir([cur_dir '/*.uint32'] ));
%     cur_nsift = cur_nsift(1,:);          
%     
%     for k2 = 1:length(cur_nsift)
%        tmp_nsift = load_ext( fullfile(cur_dir,cur_nsift{k2}));
%        tmp_ImageNum = length(tmp_nsift);
% 
%        SF_dbnsift(idx+1:idx+tmp_ImageNum) = tmp_nsift;
%        
%        idx = idx + tmp_ImageNum;
%        disp(k2);
%     end       
% end
% save_ext('./result/SF_dbnsift.uint32',SF_dbnsift);

%% part3
% SF_dbnsift = load_ext('./result/SF_dbnsift.uint32');
% num_sift   = sum(SF_dbnsift);
% SF_dbGeom  = zeros(5,num_sift,'single');
% idx = 0;
% for k1 = 1: length(sub_dir)
%     cur_dir = [feat_dir sub_dir{k1}];
%     cur_nsift = struct2cell(dir([cur_dir '/*.float'] ));
%     cur_nsift = cur_nsift(1,:);          
%     
%     for k2 = 1:length(cur_nsift)
%        tmp_geom = load_ext( fullfile(cur_dir,cur_nsift{k2}),5);
%        tmp_siftNum = size(tmp_geom,2);
% 
%        SF_dbGeom(:,idx+1:idx+tmp_siftNum) = tmp_geom;
%        
%        idx = idx + tmp_siftNum;
%        disp(k2);
%     end       
% end
% save_ext('./result/SF_dbGeom.float',SF_dbGeom);

%% part4
SF_dbnsift = load_ext('./result/SF_dbnsift.uint32');
num_sift   = sum(SF_dbnsift);
SF_dbvw  = zeros(1,num_sift,'single');
idx = 0;
for k1 = 1: length(sub_dir)
    cur_dir = [feat_dir sub_dir{k1}];
    cur_vw = struct2cell(dir([cur_dir '/*.int32'] ));
    cur_vw = cur_vw(1,:);          
    
    for k2 = 1:length(cur_vw)
       tmp_vw = load_ext( fullfile(cur_dir,cur_vw{k2}));
       tmp_siftNum = size(tmp_vw,2);

       SF_dbvw(idx+1:idx+tmp_siftNum) = tmp_vw;
       
       idx = idx + tmp_siftNum;
       disp(k2);
    end       
end
save_ext('./result/SF_dbvw.int32',SF_dbvw);