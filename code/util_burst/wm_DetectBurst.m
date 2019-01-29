function burst_Group = wm_DetectBurst(vw, geom, vvsize)

% this code is from the Repeative structure paper, Torri
% input:  
%       vw:    5 x N, visual word information
%       geom:  5 x N, geometric information
%       vvsize: n, codebook size

% output:
%       groups : 1xm cell, where m represents # of groups
%                the index of burst feature is in the same cell.

scalethr = 0.5;
edgethr  = 10;

Np   = size(vw,2);  % number of local feautres
topN = size(vw,1);  % number of knn

assgn_kNN = vw;
clear vw;

f         = zeros(3,Np);
f(1:2,:)  = geom(1:2,:);
scale     = sqrt(computeScale(geom));
f(3,:)    = scale;
clear geom;

G = cell(1,topN);
Mall = sparse(vvsize,Np);
for tt=1:topN
    assgn = assgn_kNN(tt,:);
    aid = 1:length(assgn(:));
    M = sparse(double(assgn(:)),aid,1,vvsize,Np);
    Mall = Mall + M;    
end;


%--- integrate graphs and cut too long edges on the image
A = (Mall'*Mall)>0;  
B = triu(A); 
B = B - diag(diag(B));

E = zeros(Np);
S = zeros(Np);
D = zeros(Np);
points = single(f(1:2,:));
info = single(f(3,:));

for ii=1:Np
[mi,mj] = find(B(ii,:));
    if ~isempty(mi)
        d = sqrt((points(1,mj) - points(1,ii)).^2 + (points(2,mj) - points(2,ii)).^2);
        E(ii,mj) = d;
        d = info(1,mj)./info(1,ii);
        S(ii,mj) = d;
        d = (info(1,mj)+info(1,ii))./2; % mean of scales of pair of features
        D(ii,mj) = max(5,d);
    end;
end;

E = sparse(E); E = E + E';
S = sparse(S); S = S + S';
D = sparse(D); D = D + D';

% scalethr = 0.5;
[si,sj,sk] = find(S(:));
A(si(sk<scalethr)) = 0;
A(si(sk>(1/scalethr))) = 0;

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
CC = CC(cidx);

burst_Group = CC;