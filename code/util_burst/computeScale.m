function scale = computeScale(sift_geo)

nsift = size(sift_geo,2);
scale = zeros(1,nsift);

for k1 = 1:nsift
     curr_Geo = sift_geo(:,k1);
         
     q_a = curr_Geo(3);
     q_b = curr_Geo(4);
     q_c = curr_Geo(5);
     
     %scale(k1) = -log(q_a*q_c-q_b*q_b)/2;
     scale(k1) = 1 / sqrt(q_a*q_c-q_b*q_b);
end