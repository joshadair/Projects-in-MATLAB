function [final,frames,vid_frames]=sandartimg(image,initial,frames,edgecondition)

if isempty(initial)
    initial=padarray(image,[10 10]);
else
    initial(11:end-10,11:end-10)=image;
end

trigger=0;
if isempty(frames)
    frames{end+1}=initial;
end

test_edgecondition=edgecondition;
if strcmp(test_edgecondition,'falloff')==1  
    test_edgecondition=1;
elseif strcmp(test_edgecondition,'grow')==1
    test_edgecondition=2;
    edges=[initial(1,:),initial(end,:),initial(:,1)',initial(:,end)'];  
    if max(edges) > 3 
        initial=padarray(initial,[1 1]);  
    end
end

[row,col]=size(initial);
new=initial;

%while

for r=1:row
     if trigger==1           
         trigger=0;            
         continue;       
     end
    for c=1:col
        if initial(r,c)>3
            % If using falloff condition for edges of table, need to
            % account for critical points at pile corners and edges
            if test_edgecondition==1
                if r==1 && c==1                   
                    new(r+1,c)=new(r+1,c)+1;                                                                             
                    new(r,c+1)=new(r,c+1)+1;                           
                    new(r,c)=new(r,c)-4;                   
                elseif r==1 && c==col                    
                    new(r+1,c)=new(r+1,c)+1;                               
                    new(r,c-1)=new(r,c-1)+1;                                                                         
                    new(r,c)=new(r,c)-4;
                elseif r==row && c==1
                    new(r-1,c)=new(r-1,c)+1;                                                                                                 
                    new(r,c+1)=new(r,c+1)+1;                           
                    new(r,c)=new(r,c)-4;                    
                elseif r==row && c==col
                    new(r-1,c)=new(r-1,c)+1;                                                   
                    new(r,c-1)=new(r,c-1)+1;                                                                         
                    new(r,c)=new(r,c)-4;
                elseif r==1                   
                    new(r+1,c)=new(r+1,c)+1;                               
                    new(r,c-1)=new(r,c-1)+1;                          
                    new(r,c+1)=new(r,c+1)+1;                           
                    new(r,c)=new(r,c)-4;                    
                elseif r==row
                    new(r-1,c)=new(r-1,c)+1;                                                   
                    new(r,c-1)=new(r,c-1)+1;                          
                    new(r,c+1)=new(r,c+1)+1;                           
                    new(r,c)=new(r,c)-4;                    
                elseif c==1
                    new(r-1,c)=new(r-1,c)+1;
                    new(r+1,c)=new(r+1,c)+1;                                                                             
                    new(r,c+1)=new(r,c+1)+1;                           
                    new(r,c)=new(r,c)-4;                    
                elseif c==col
                    new(r-1,c)=new(r-1,c)+1;
                    new(r+1,c)=new(r+1,c)+1;                               
                    new(r,c-1)=new(r,c-1)+1;                                                                         
                    new(r,c)=new(r,c)-4;                   
                else                    
                    new(r-1,c)=new(r-1,c)+1;
                    new(r+1,c)=new(r+1,c)+1;                               
                    new(r,c-1)=new(r,c-1)+1;                          
                    new(r,c+1)=new(r,c+1)+1;                           
                    new(r,c)=new(r,c)-4;                    
                end                                                                                        
            end
            
            % If edge condition is set to allow for growing sand piles,
            % then need to use padarray to extend matrix when an edge
            % element has a value >=4. Note, this can also be accomplished
            % by padding initial matrix with sufficient space from the
            % beginning of the process
            if test_edgecondition == 2               
                % During iterations, it's possible for edges to accumulate           
                % value > 3, if this happens, there are two options:
                % 1. 'continue' to preserve current value for later evaluation
                % 2. Use recursion to cycle back through beginning to trigger
                % padding statement. This accomodation is important for more accurately preserving 
                % the symmetry of the sandpile through the iterations
                % ^^^review...may no longer be relevant with updated
                % initial/new structure and change from recursion to while
                if r==1 || r==row || c==1 || c==col
                    trigger=1;
                    %[final,frames,vid_frames] = abeliansand(initial,frames);
                    %continue                                      
                    new=padarray(new,[1 1]);
                    row=row+1;
                    col=col+2;
                    r=r+1;
                    c=c+1;
               
                    % indices into initial matrix need to be reviewed as
                    % dimensions for new>initial (maybe keep increasing
                    % trigger +1 and use that to account for size increases
                    new(r-1,c)=initial(r-1,c)+1;
                    new(r+1,c)=initial(r+1,c)+1;                               
                    new(r,c-1)=initial(r,c-1)+1;                          
                    new(r,c+1)=initial(r,c+1)+1;                           
                    new(r,c)=initial(r,c)-4;               
                    break                                          
                end
                       
                new(r-1,c)=initial(r-1,c)+1;
                new(r+1,c)=initial(r+1,c)+1;                               
                new(r,c-1)=initial(r,c-1)+1;                          
                new(r,c+1)=initial(r,c+1)+1;                           
                new(r,c)=initial(r,c)-4;                    
            end           
        end
    end    
end

%end

% Update methodology above to use while loop based on max(max(new/initial)) instead of
% recursion and methodology below to process cell frames into vid

% If piles still have values greater than 3 (4+), then add current
% iteration to frames{} and recursively call parent function again to
% continue with algorithm at next iteration

% Once sandpile distribution has been completed, process frames{} in order
% output video file
if numel(frames)>1000 || max(max(new))<=3 
    final=new;    
    frames{end+1}=final;      
    % Helper function that accounts for growing pile size and pads      
    % smaller piles with 0's (black border) so that all piles are equal to      
    % final pile size, the result is seen in the final video where the      
    % total area of pile seems to grow and relative pixel size stays      
    % constant           
    % vid_frames=normalizesandsize(frames);
    vid_frames=frames;

    for x=1:length(vid_frames)         
        %vid_frames{x} = linearizeim(vid_frames{x});          
        vid_frames{x}=ind2rgb(vid_frames{x},turbo(10));          
        vid_frames{x}=imresize(vid_frames{x},[1000 1000],'box');    
    end
        
    duration=45; %seconds      
    %framerate=length(vid_frames)/duration;          
    for count=1:ceil(duration*.05)      
        % Create still frames of initial condition
        vid_frames=cat(2,vid_frames{1},vid_frames);                  
        % Create still frames of stable, end condition         
        vid_frames{end+1}=vid_frames{end};
    end
    
    cell2vid(vid_frames,'abeliansand_flow.mp4',duration);


elseif max(max(new))>3     
    frames{end+1}=new;      
    [final,frames,vid_frames]=sandartimg(image,new,frames,edgecondition);

end
end