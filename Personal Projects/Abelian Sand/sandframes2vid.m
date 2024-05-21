function average=sandframes2vid(frames,edgeCondition,filename,duration)

if strcmp(edgeCondition,'grow')==1
    frames=normalizesandsize(frames);
end

frames=frames+1;

v=VideoWriter(filename,'Indexed AVI');
framerate=floor(length(frames)/duration);
v.FrameRate=framerate;

cmapList={'Parula','Turbo','HSV','Hot','Cool','Winter','Spring','Summer','Autumn','Sky','Abyss'};
[indx,~]=listdlg('PromptString',"Please select a colormap from the list below...",'ListString',cmapList,'SelectionMode','single');
numCol=max(max(max(frames)))+1;
cmapName=cat(2,cmapList{indx},'(',num2str(numCol),')');
cmap=colormap(cmapName);
v.Colormap=cmap;

average=zeros(size(frames,2));
for i1=1:size(frames,3)
    temp=ind2rgb(frames(:,:,i1),cmap);
    average=average+temp;
end
average=average/size(frames,3);
average=imresize(average,[1080 1080],'box');
imshow(average)

% Pad beginning of video with additional frames of initial setup
for i1=1:ceil(length(frames)*.04)
    frames=cat(3,frames(:,:,1),frames);
end

% Pad end of video with additional frames of final position
for i1=1:ceil(length(frames)*.08)
    frames=cat(3,frames,frames(:,:,end));
end

frames=imresize(frames,[540 540],'box');

open(v);
writeVideo(v,frames);
close(v);
end
