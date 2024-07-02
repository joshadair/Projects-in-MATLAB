function average=sandframes2gif(frames,gifsizeRows,gifsizeCols,edgeCondition,filename)

if strcmp(edgeCondition,'grow')==1
    frames=normalizesandsize(frames);
end
%{
cmapList={'Parula','Turbo','HSV','Hot','Cool','Winter','Spring','Summer','Autumn','Sky','Abyss'};
[indx,~]=listdlg('PromptString',"Please select a colormap from the list below...",'ListString',cmapList,'SelectionMode','single');

numCol=max(max(max(frames)))+1;
cmapName=cat(2,cmapList{indx},'(',num2str(numCol),')');
%}
cmap=colormap(turbo(max(max(max(frames)))+1));

frames=frames+1; % add 1 to convert to index colormap range, i.e. cannot have value of 0 in indexed image, loses color difference of 0 to 1
frames=imresize(frames,[gifsizeRows gifsizeCols],'box');
average=zeros(gifsizeRows,gifsizeCols,3);
nFrames=size(frames,3);

for i1=1:nFrames
    active=frames(:,:,i1);
    temp=ind2rgb(active,cmap);
    average=average+temp;

    if i1==1
        imwrite(active,cmap,filename,"gif","LoopCount",Inf,"DelayTime",0.5);
    else
        imwrite(active,cmap,filename,"gif","WriteMode","append","DelayTime",0.5);
    end
end

average=average/nFrames;
average=imresize(average,[1080 1080],'box');
imshow(average)

end
