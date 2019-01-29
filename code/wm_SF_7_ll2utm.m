% transform the longtitute and latitute positiion to UTM position by the
% Pittsburgh code ''lltoutm.m'

%load SF filename
load('./result/SF_dbImageFns.mat');

num_db = length(SF_dbImageFns);
db_utm = zeros(num_db,2);
db_ll  = zeros(num_db,2);

for k1 = 1:num_db
    tmp_fname = SF_dbImageFns{k1};
    tmp_str   = regexp(tmp_fname,'_','split');
    
    tmp_lon   = str2double( tmp_str{7} );
    tmp_lat   = str2double( tmp_str{6} );  
    db_ll(k1,1) = tmp_lat;
    db_ll(k1,2) = tmp_lon;
    
    [tmp_utme,tmp_utmn] = lltoutm(tmp_lat, tmp_lon); 
    db_utm(k1,:) = [tmp_utme,tmp_utmn] ;
    
    if (k1 / 1000 == round( k1 / 1000))
        disp(k1);
    end
end

save('../data/SF_database_1062468_utm.mat','db_utm','db_ll');
