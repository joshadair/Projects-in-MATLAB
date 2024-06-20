function average=sandframes2vid(frames,edgeCondition,filename,framerate)

if strcmp(edgeCondition,'grow')==1
    frames=normalizesandsize(frames);
end

frames=frames+1;

v=VideoWriter(filename,'MPEG-4');
v.FrameRate=framerate;

cmapList={'Parula','Turbo','HSV','Hot','Cool','Winter','Spring','Summer','Autumn','Sky','Abyss'};
[indx,~]=listdlg('PromptString',"Please select a colormap from the list below...",'ListString',cmapList,'SelectionMode','single');
numCol=max(max(max(frames)));
cmapName=cat(2,cmapList{indx},'(',num2str(numCol),')');
cmap=colormap(cmapName);
%v.Colormap=cmap;

[row,col,nFrames]=size(frames);
average=zeros(row,col);
for i1=1:nFrames
    temp=ind2rgb(frames(:,:,i1),cmap);
    average=average+temp;
end
average=average/nFrames;
average=imresize(average,[1080 1080],'box');
imshow(average)

% Pad video with additional start frames
for i1=1:ceil(length(frames)*.04)
    frames=cat(3,frames(:,:,1),frames);
end

% Pad video with additional end frames
for i1=1:ceil(length(frames)*.08)
    frames=cat(3,frames,frames(:,:,end));
end
%}
frames=imresize(frames,[720 720],'box');

open(v);
writeVideo(v,frames);
close(v);
end
