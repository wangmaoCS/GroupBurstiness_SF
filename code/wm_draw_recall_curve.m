%recall on SF for minNorm

x  = [1 5 10 20 50];
y1 = [0.6787 0.7796 0.8132 0.8269 0.8493 ];
y2 = [0.7061  0.7908 0.8169 0.8281 0.8518];
plot(x,y1,'b--o',x,y2,'r-.*','LineWidth',2,'MarkerSize',10);
title('San Francisco (HE)','FontSize',20);
xlabel('N-Number of top database candidates','FontSize',20);
ylabel('Recall@N(%)','FontSize',20);
hleg1 = legend('Original Sim','Our Sim');
set(hleg1,'Location','SouthEast')
grid on
set(gca,'FontSize',15)