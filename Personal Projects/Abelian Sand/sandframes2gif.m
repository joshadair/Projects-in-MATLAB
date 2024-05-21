function average=sandframes2gif(frames,gifsize,edgeCondition,filename)
%set(0,'DefaultFigureVisible','off');
if strcmp(edgeCondition,'grow')==1
    frames=normalizesandsize(frames);
end

cmapList={'Parula','Turbo','HSV','Hot','Cool','Winter','Spring','Summer','Autumn','Sky','Abyss'};
[indx,~]=listdlg('PromptString',"Please select a colormap from the list below...",'ListString',cmapList,'SelectionMode','single');

%numCol=max(max(max(frames)))-1;
numCol=24;
cmapName=cat(2,cmapList{indx},'(',num2str(numCol),')');
cmap=colormap(cmapName);
%cmap=slanCM('turbo',numCol);
%cmap(1,:)=[0 0 0];
%cmap(end+1,:)=[1 1 1];

%{
% Pad beginning of video with additional frames of initial setup
for i1=1:ceil(length(frames)*.04)
    frames=cat(3,frames(:,:,1),frames);
end

% Pad end of video with additional frames of final position
for i1=1:ceil(length(frames)*.08)
    frames=cat(3,frames,frames(:,:,end));
end
%}

frames=imresize(frames,[gifsize gifsize],'box');

average=zeros(gifsize,gifsize,3);
nFrames=size(frames,3);

for i1=1:nFrames
    active=frames(:,:,i1)+1; % add 1 to convert to index colormap range, i.e. cannot have value of 0 in indexed image, loses color difference of 0 to 1
    temp=ind2rgb(active,cmap);
    average=average+temp;

    if i1==1
        imwrite(active,cmap,filename,"gif","LoopCount",Inf,"DelayTime",0.1);
    else
        imwrite(active,cmap,filename,"gif","WriteMode","append","DelayTime",0.1);
    end
end

average=average/nFrames;
average=imresize(average,[1080 1080],'box');
imshow(average)

end
