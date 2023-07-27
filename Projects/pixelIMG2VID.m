function [exportVid,exportAllImg] = pixelIMG2VID(fileName)
exportAllImg = {};
input = imread(fileName);
sizeArray = size(input);
r = sizeArray(1);
c = sizeArray(2);

divr = divisors(r);
divc= divisors(c);
cmndiv = intersect(divr,divc);

exportVid = VideoWriter('pixelVideo.avi','Motion JPEG AVI');
exportVid.FrameRate = 1;
open(exportVid);


for x=length(cmndiv):-1:1
    pixelImage = pixelate(fileName,'image',cmndiv(x));
    newFrame = im2frame(pixelImage);
    exportAllImg{end+1} = pixelImage;
    for y=1:1
        %use y=1:1 to create 1 frame per iteration, otherwise
        %round(((cmndiv(x)-1)/(cmndiv(x)))*#+1) attempts to create a
        %weighted value that lengthens display iterations with larger
        %pixel/grain size by writing more of those frames
        writeVideo(exportVid,newFrame);
    end
end

close(exportVid);

end

