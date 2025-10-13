function out=aoc16_1_b()
x=0;
y=0;
out=[0,0];
in=fileread('day1a.txt');
in=strsplit(in,',');
[r,c]=size(in);
% dir_bin=['N' 'W' 'S' 'E'];
start_dir=1;
active_dir=start_dir;


for i1=1:1:c
    next_dir=strtrim(in{i1});
    turn=next_dir(1);
    magn=polyval(next_dir(2:end)-'0',10);
    if turn=='L'
        active_dir=active_dir+1;
    else
        active_dir=active_dir-1;
    end
    
    if active_dir==0
        active_dir=4;
    elseif active_dir==5
        active_dir=1;
    end
    
    for i2=1:1:magn
        
        if active_dir==1
            y=y+1;
        elseif active_dir==2
            x=x-1;
        elseif active_dir==3
            y=y-1;
        elseif active_dir==4
            x=x+1;
        end
        
        [Lia,Locb]=ismember([x,y],out,'rows');
        if Lia==true
            out=x+y;
            return
        else
            out=[out;[x,y]];
        end
        
    end
    
end
end
