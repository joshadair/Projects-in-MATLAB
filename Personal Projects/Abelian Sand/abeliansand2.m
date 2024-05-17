function final=abeliansand2(initial)
[row,col]=size(initial);
new=initial;

while max(max(new))>3
    initial=new;

    for r=1:row
        for c=1:col
            if initial(r,c)>3
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
        end
    end
end
final=new;

end