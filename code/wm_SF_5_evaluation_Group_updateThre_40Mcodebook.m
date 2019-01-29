% 
% addpath('./Evaluation_Package/');
% 
% qPath  = '/run/media/401/DataBackup/public_data/SF/sf/BuildingQueryImagesCartoIDCorrected-Upright/';
% dbPath = '/run/media/401/DataBackup/public_data/SF/PCI_image/img/';
% 
% feat_dir = '/run/media/401/DataBackup/public_data/SF/PCI_image/feature/';
% 
% % load query fname
% feature_path_q = [feat_dir 'query/'];
% load([feature_path_q 'query_feature_fname']); 
% qImageFns  = dbImageFns;
% 
% % % load database fname information
% % load('./result/dbImageIndexInfor.mat','dbImageFnsIndex','sub_FeatFns','sub_dir');
% load('./result/SF_dbImageFns.mat','SF_dbImageFns');
% 
% %load inital query result 
% load('./result_updateThre_group_40Mcodebook/result_list_top1000_24_knn5_burst.mat');
% 
% feature_path_db = [feat_dir 'db/'];
% 
% numQueryImages = length(qImageFns);
% numTopMatches  = 1000;
% 
% % Read ground truth file
% %groundTruth = readGroundTruthFile('cartoid_groundTruth.txt', numQueryImages);
% groundTruth = readGroundTruthFile('cartoid_groundTruth_2014_04.txt', numQueryImages);
% 
% correct = zeros(numQueryImages, numTopMatches);
% 
% tic;
% for nImage = 1:numQueryImages
%     
%     for nTop = 1:numTopMatches      
%        databaseImageName = SF_dbImageFns{result_list(nTop,nImage)};
%                     
%        foundGround = 0;
%         for nGround = 1:length(groundTruth{nImage})
%             foundGround = ~isempty(strfind(databaseImageName, groundTruth{nImage}{nGround}));
%             if foundGround
%                 break;
%             end
%         end % nGround
%         correct(nImage, nTop) = foundGround;       
%     end
%     disp(nImage);
% end
% toc;
% %Elapsed time is 17.216023 seconds.
% 
% %save('./result_updateThre/correct_top50_ht24_knn5_burst_gt2014.mat','correct');
% save('./result_updateThre_group_40Mcodebook/correct_top50_ht24_knn5_burst_gt2014.mat','correct');
% 
% recallAt1 = sum(correct(:,1)) / numQueryImages

load('./result_updateThre_group_40Mcodebook/correct_top50_ht24_knn5_burst_gt2014.mat','correct');
%load('./result_updateThre_40Mcodebook/correct_top50_ht24_knn5_gt2014.mat','correct');
%load('./result_updateThre/correct_top50_ht24_knn5_gt2014.mat','correct');
correct = correct'; 
numQueryImages = size(correct,2);
recallAt1 = sum(correct(1,:)) / numQueryImages  ; 
recallAt2 = sum(sum(correct(1:2,:)) > 0) / numQueryImages; 
recallAt5 = sum(sum(correct(1:5,:)) > 0) / numQueryImages; 
recallAt10 = sum(sum(correct(1:10,:)) > 0) / numQueryImages; 
recallAt20 = sum(sum(correct(1:20,:)) > 0) / numQueryImages;
recallAt30 = sum(sum(correct(1:30,:)) > 0) / numQueryImages;
recallAt40 = sum(sum(correct(1:40,:)) > 0) / numQueryImages;
recallAt50 = sum(sum(correct(1:50,:)) > 0) / numQueryImages;

%recall@1 = 0.6712: burst
%recallAt1 = 0.6264

%recall@1  = 0.6787
%recall@2  = 0.7372
%recall@5  = 0.7796
%recall@10 = 0.8132
%recall@20 = 0.8269
%recall@30 = 0.8356
%recall@40 = 0.8468
%recall@50 = 0.8493


%recallAt1 = 0.7148
%recallAt2 = 0.7609
%recallAt5 = 0.8032
%recallAt10 = 0.8257
%recallAt20  = 0.8484
%recall@30 = 0.8580
%recall@40 = 0.8605
%recallAt50 = 0.8655