function [final,frames,vid_frames] = abeliansand(initial,frames)
  [row,col] = size(initial);
  
  for r=1:row
      for c=1:col
          if initial(r,c) > 3
              if r == 1
                  initial = [zeros(1,col); initial];
                  r = 2;
                  row = row + 1;
              end
              
              if r == row
                  initial = [initial; zeros(1,col)];
                  row = row + 1;
              end
              
              if c == 1
                  initial = [zeros(row,1), initial];
                  c = 2;
                  col = col + 1;
              end
              
              if c == col
                  initial = [initial, zeros(row,1)];
                  col = col + 1;
              end
                            
              initial(r-1,c) = initial(r-1,c) + 1;
              initial(r+1,c) = initial(r+1,c) + 1;                               
              initial(r,c-1) = initial(r,c-1) + 1;              
              initial(r,c+1) = initial(r,c+1) + 1;              
              initial(r,c) = initial(r,c) - 4;
          end
      end
  end
  
  if sum(any(initial>3)) > 0
      frames{end+1} = initial; 
      [final,vid_frames,frames] = abeliansand(initial,frames);
  else
      final = initial;
      frames{end+1} = final;
      vid_frames = frames;
      for x=1:length(vid_frames)
          vid_frames{x} = linearizeim(vid_frames{x});
          %vid_frames{x} = double2rgb(vid_frames{x},jet)
          vid_frames{x} = imresize(vid_frames{x},[400 400],'box');
      end
      
      duration = 60;
      frame_rate = length(vid_frames)/duration;    
      for count=1:3*frame_rate          
          % Trying to create still frames of initial condition; however,
          % this technically is the first iteration of the pile - need to
          % try to use "recover" or preserve initial matrix
          vid_frames = cat(2,vid_frames{1},vid_frames);
          
          % Create still frames of stable end condition
          vid_frames{end+1} = vid_frames{end};
      end 
      cell2vid(vid_frames,'abeliansand_flow.mp4',frame_rate);
  end

end