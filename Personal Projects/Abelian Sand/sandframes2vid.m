function average=sandframes2vid(frames,edgeCondition,filename,duration)
set(0,'DefaultFigureVisible','off');
if strcmp(edgeCondition,'grow')==1
    frames=normalizesandsize(frames);
end

[row,col]=size(frames(:,:,end));
average=zeros(row,col,3);
video=VideoWriter(filename,'Indexed AVI');
framerate=floor(length(frames)/duration);
video.FrameRate=framerate;

cmapList={'Parula','Turbo','HSV','Hot','Cool','Winter','Spring','Summer','Autumn','Sky','Abyss'};
[indx,~]=listdlg('PromptString',"Please select a colormap from the list below...",'ListString',cmapList,'SelectionMode','single');

%numCol=max(max(max(frames)))-1;
numCol=max(max(max(frames)));
%cmapName=cat(2,cmapList{indx},'(',num2str(numCol),')');
%cmap=colormap(cmapName);
cmap=slanCM('turbo',numCol);
cmap(1,:)=[0 0 0];
%cmap(end+1,:)=[1 1 1];
video.Colormap=cmap;

%{
% Pad beginning of video with additional frames of initial setup
for i1=1:ceil(length(frames)*.04)
    frames=cat(3,frames(:,:,1),frames);
end

% Pad end of video with additional frames of final position
for i1=1:ceil(length(frames)*.08)
    frames=cat(3,frames,frames(:,:,end));
end


for i1=1:length(frames)
    temp=ind2rgb(frames(:,:,i1),cmap);
    average=average+temp;
    %temp=imresize(temp,[1080 1080],'box');
    %writeVideo(video,temp);
end

average=average/length(frames);
average=imresize(average,[1080 1080],'box');
imshow(average)
%}

open(video);
writeVideo(video,frames);
close(video);
end
