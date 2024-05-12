function drawframe_joy(f)

data=readmatrix(websave('pulsar.csv','https://gist.githubusercontent.com/borgar/31c1e476b8e92a11d7e9/raw/0fae97dab6830ecee185a63c1cee0008f6778ff6/pulsar.csv'));
x = linspace(0,93,size(data,2)); 
joyPlot(data',x,4)
set(gcf,'position',[500,100,560,680],'InvertHardcopy','off')
set(gca,'Visible','off', 'box','off','XTick',[],'YTick',[])

joyPlot(data,x,4,'FaceColor',mean(data,2))
colorbar

end