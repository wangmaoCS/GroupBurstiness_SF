function wm_Viz_burstFeature(img,geom,CC)

f = geom;

wmax = 3;
Np   = size(geom,2);
K = zeros(1,Np);
for jj=1:length(CC)
  id = CC{jj};
  K(id) = length(id);
end;
K = log((Np+1)./K);
K = ceil((K./max(K))*wmax);

%--- visualization 
figure;
imshow(img,'border','tight'); hold on;
colormap('gray'); axis image; axis off; hold on;
plot(f(1,:),f(2,:),'o','MarkerSize',4,'MarkerFaceColor','w','MarkerEdgeColor','k'); %[.99 .99 .99]);
set(gcf,'position',[100 500 320 280]);
title('Detected features');

figure;
Nmax = min(10,length(CC));
ccid = CC(1:Nmax);
C = colormap('jet');
cw = ceil(linspace(56,9,Nmax));
imshow(img,'border','tight'); hold on;
colormap('gray'); axis image; axis off; hold on;
for ii=Nmax:-1:1
  pts = f(1:2,ccid{ii});
  plot(pts(1,:),pts(2,:),'o','MarkerSize',4,'MarkerFaceColor',C(cw(ii),:),'MarkerEdgeColor','k');
end;
set(gcf,'position',[440 500 320 280]);
title('Detected repttles (10 lagest)');

figure;
C = colormap('jet');
imshow(img,'border','tight'); hold on;
colormap('gray'); axis image; axis off; hold on;
clr = 'rgb';
for pp=1:3
  pts = f(1:2,K==pp);
  plot(pts(1,:),pts(2,:),'o','MarkerSize',4,'MarkerFaceColor',clr(pp),'MarkerEdgeColor','k');
end;
set(gcf,'position',[780 500 320 280]);
title('Features with one (red), two (green), or three (blue) assignments');