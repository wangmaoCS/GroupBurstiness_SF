
% load centroids file
load('../codebook_data/codebook_SF_200k_rootsift_40M.mat');
num_codebook = size(codebook,2);

%load vw file to compute the idf information
vw_path = '../data/SF_dbvw_40Mcodebook.int32';
vw      = load_ext(vw_path);
idf_num = zeros(num_codebook,1);

%load image Fns
dbFns_path  = './result/SF_dbImageFns';
load(dbFns_path,'SF_dbImageFns');
num_db  = length(SF_dbImageFns);
clear SF_dbImageFns;

for k1 = 1: length(vw)
     tmp_vw = vw(k1);   
     idf_num(tmp_vw) = idf_num(tmp_vw) + 1;  
     if ( k1/10000 == round(k1 /10000))
         disp(k1)
     end
end

idf_data = zeros(1,num_codebook);
for k1 = 1:num_codebook
    if(idf_num(k1) > 0)
        idf_data(k1) = log(num_db ./ idf_num(k1));
    end
end

save('../data/SF_idf_40Mcodebook_maxIDF.mat','idf_data');  




