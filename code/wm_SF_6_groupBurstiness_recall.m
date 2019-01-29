%plot the recall for group burstiness;


x  = [1 5 10 20 30 40 50];
y1 = [0.6787 0.7372 0.8132 0.8269   0.8356 0.8468  0.8493 ];
y2 = [0.7148  0.8032 0.8257 0.8484 0.8580 0.8605   0.8655];
plot(x,y1,'b--o',x,y2,'r-.*','LineWidth',2,'MarkerSize',10);
title('San Francisco (HE)','FontSize',20);
xlabel('N-Number of top database candidates','FontSize',20);
ylabel('Recall@N','FontSize',20);
hleg1 = legend('i2-burstiness','group burstiness');
set(hleg1,'Location','SouthEast')
grid on
set(gca,'FontSize',15)