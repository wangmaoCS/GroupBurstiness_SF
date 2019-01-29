%display the location of SF database

load('../data/SF_database_1062468_utm.mat','db_utm','db_ll');

plot(db_utm(:,1), db_utm(:,2),'r.');

grid on;
title('SF database map');
