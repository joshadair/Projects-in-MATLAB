
  filename = websave('pulsar.csv',['https://gist.githubusercontent.com/borgar/',...
     '31c1e476b8e92a11d7e9/raw/0fae97dab6830ecee185a63c1cee0008f6778ff6/',...
     'pulsar.csv']);
%   % Import it into MATLAB(R)
   data = readmatrix(filename);
   x = linspace(0,93,size(data,2));
%   % Create the figure and show the magic
   figure
   joyPlot(data',x,4)
   set(gcf,'position',[500,100,560,680])
   set(gca,'Visible','off', 'box','off','XTick',[],'YTick',[])