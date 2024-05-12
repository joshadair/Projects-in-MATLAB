function [final,frames,vid_frames]=fastsandart(initial,frames)
if isempty(frames)==1
    frames{end+1}=initial;
end

[row,col]=size(initial);
new=initial;

%while

for r=1:row
    for c=1:col
        if initial(r,c)>3
                new(r-1,c)=new(r-1,c)+1;
                new(r+1,c)=new(r+1,c)+1;
                new(r,c-1)=new(r,c-1)+1;
                new(r,c+1)=new(r,c+1)+1;
                new(r,c)=new(r,c)-4;
        end
    end
end

%end

if max(max(new))>3
    frames{end+1}=new;
    [final,frames,vid_frames]=fastsandart(new,frames);

else
    final=new;
    frames{end+1}=final;
    % Helper function that accounts for growing footprint size and pads
    % smaller footprints with 0's (black border) so that all iterations 
    % have equal dimensions, the result is seen in the final video where
    % the total area of pile seems to grow and relative pixel/pile size
    % stays constant --- not needed if initial condition is already padded
    % vid_frames=normalizesandsize(frames);
    vid_frames=frames;

    for x=1:length(vid_frames)
        %vid_frames{x} = linearizeim(vid_frames{x});
        vid_frames{x}=double2rgb(vid_frames{x},jet);
        vid_frames{x}=imresize(vid_frames{x},[1000 1000],'box');
    end

    duration=30;
    framerate=length(vid_frames)/duration;
    for count=1:2*framerate
        vid_frames=cat(2,vid_frames{1},vid_frames);
        vid_frames{end+1}=vid_frames{end};
    end

    cell2vid(vid_frames,'abeliansand_flow.mp4',framerate);
end

end