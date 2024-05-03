function sandframes2vid(frames,edgeCondition,filename,duration)
video=VideoWriter(filename,'MPEG-4');
framerate=floor(numel(frames)/duration);
video.FrameRate=framerate;
open(video);

cmapList={'Parula','Turbo','HSV','Hot','Cool','Winter','Spring','Summer','Autumn','Sky','Abyss'};
[indx,~]=listdlg('PromptString',"Please select a colormap from the list below...",'ListString',cmapList,'SelectionMode','single');

prompt={'How many colors to use?'};
numCol=inputdlg(prompt,'',1,"10");

cmapName=cat(2,cmapList{indx},'(',char(numCol),')');
cmap=colormap(cmapName);

if strcmp(edgeCondition,'grow')==1
    frames=normalizesandsize(frames);
end

for i1=1:numel(frames)
    temp=ind2rgb(frames{i1},cmap);
    temp=imresize(temp,[1080 1080],'box');
    writeVideo(video,temp);
end

end
