function [average,a2]=sandframes2gif(frames,gifSize,edgeCondition,filename)

if strcmp(edgeCondition,'grow')==1
    frames=normalizesandsize(frames);
end
%{
cmapList={'Parula','Turbo','HSV','Hot','Cool','Winter','Spring','Summer','Autumn','Sky','Abyss'};
[indx,~]=listdlg('PromptString',"Please select a colormap from the list below...",'ListString',cmapList,'SelectionMode','single');

numCol=max(max(max(frames)))+1;
cmapName=cat(2,cmapList{indx},'(',num2str(numCol),')');
%}


frames=frames+1; % add 1 to convert to index colormap range, i.e. cannot have value of 0 in indexed image, loses color difference of 0 to 1
cmap=colormap(turbo(max(max(max(frames)))));
frames=imresize(frames,[gifSize gifSize],'box');
average=zeros(gifSize,gifSize,3);
nFrames=size(frames,3);

for i1=1:nFrames
    active=frames(:,:,i1);
    if strcmp(edgeCondition,'grow')==1
        cmap=colormap(turbo(10));
    end
    temp=ind2rgb(active,cmap);
    average=average+temp;
    if i1==1
        imwrite(active,cmap,filename,"gif","LoopCount",Inf,"DelayTime",1);
    elseif i1==nFrames
        imwrite(active,cmap,filename,"gif","WriteMode","append","DelayTime",1);
    else
        imwrite(active,cmap,filename,"gif","WriteMode","append","DelayTime",0.03);
    end
end

average=average/nFrames;
a2=imresize(average,[1080 1080]);
average=imresize(average,[1080 1080],'box');

end
