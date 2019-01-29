function [inlier_BurstWeight, bstGroup]= BurstFeatureDetection(feat,vw,codebook_size)
%this script is used to detection burstiness for the query images for the
%group burstiness, we try to use some feature matching strategy, such as
%HA,MA,SA,LR_SA
% the input is 
%               1: cur_match, the matching information
%               2: feat, the feature
 
%     scalethr = 0.8;
%     edgethr = 2;

%     scalethr = 0.8;
%     edgethr = 10;   %mAP = 0.6725

    scalethr = 0.5;
    edgethr = 10;     % mAP = 0.6721

num_feat = size(feat,2);

% get visual word matrix
full_vw = zeros(codebook_size, num_feat);
for k1 = 1:num_feat
%   full_vw(vw(:,k1),k1) = 1;  old version
    
    vw_idx = vw(:,k1) > 0 ;
    full_vw(vw(vw_idx,k1),k1) = 1;
end

%compute the scale of each feature
scale_info = sqrt(computeScale(feat));

% get center location
points     = feat(1:2,:);

% compute the vw similarity of each feature
thre_vw = 3;
Mall =full_vw' * full_vw;
A = Mall>thre_vw;  
B = triu(A); 
B = B - diag(diag(B));

E = zeros(num_feat);    % center point distance
S = zeros(num_feat);    % scale difference
D = zeros(num_feat);    % scale mean

for ii = 1:num_feat
    [mi,mj] = find(B(ii,:));
    if ~isempty(mi)     
        d_e = sqrt((points(1,mj) - points(1,ii)).^2 + (points(2,mj) - points(2,ii)).^2);
        E(ii,mj) = d_e;
        d = scale_info(1,mj)./scale_info(1,ii);
        S(ii,mj) = d;
        d = (scale_info(1,mj)+scale_info(1,ii))./2; % mean of scales of pair of features
        D(ii,mj) = max(5,d);
    end   
end

E = E + E';
S = S + S';
D = D + D';


%constrain : scale difference should below a threshold

[si,sj,sk] = find(S(:));
A(si(sk<scalethr)) = 0;
A(si(sk>(1/scalethr))) = 0;

% %constrain : center distance should below the distance of scale

Z = E > edgethr*D;
A(Z(:)) = 0;

%--- find connected components in the graph, breath first search
[bp, bq, br, bs] = dmperm(A);

Nc = length(br)-1;
CC = cell(1,Nc);

ncVsz = zeros(1,Nc);
for ii=1:Nc
id = bp(br(ii):br(ii+1)-1);
ncVsz(ii) = length(id);
CC{ii} = id;
end;

[~,cidx] = sort(ncVsz,'descend');  
bstGroup = CC(cidx);

%get the burst group information
num_group = length(bstGroup);
inlier_BurstWeight = zeros(num_feat,1);

for k1 = 1:num_group
   cur_idx = bstGroup{k1};
   num_idx = size(cur_idx,2);
   %inlier_BurstWeight(cur_idx) = 1 / num_idx;
   inlier_BurstWeight(cur_idx) = 1 / sqrt(num_idx);
end