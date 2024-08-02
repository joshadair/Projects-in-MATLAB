function frames=sand(in,pattern,edge)

if strcmp(edge,'falloff')==1
    edge=1;
    frames=[];
    frames(:,:,1)=in;
elseif strcmp(edge,'grow')==1
    edge=2;
    frames={};
    frames{end+1}=in;
end
[row,col]=size(in);
new=in;

if strcmp(pattern,'plus')==1
    while max(max(new))>3
        in=new;
        if edge==2
            edges=[in(1,:),in(end,:),in(:,1)',in(:,end)'];
            if max(edges)>3
                in=padarray(in,[1 1]);
                new=in;
                [row,col]=size(in);
            end
        end

        for r=1:row
            for c=1:col
                if in(r,c)>3
                    try new(r-1,c)=new(r-1,c)+1;
                    catch
                    end
                    try new(r+1,c)=new(r+1,c)+1;
                    catch
                    end
                    try new(r,c-1)=new(r,c-1)+1;
                    catch
                    end
                    try new(r,c+1)=new(r,c+1)+1;
                    catch
                    end
                    try new(r,c)=new(r,c)-4;
                    catch
                    end
                end
            end
        end
        if edge==1
            frames=cat(3,frames,new);
        elseif edge==2
            frames{end+1}=new;
        end
    end
end

if strcmp(pattern,'decay8')==1
    while max(max(new))>31
        in=new;
        if edge==2
            edges=[in(1,:),in(end,:),in(:,1)',in(:,end)'];
            if max(edges)>31
                in=padarray(in,[1 1]);
                new=in;
            end
        end

        for r=1:row
            for c=1:col
                if in(r,c)>31
                    % inner ring
                    try new(r-1,c-1)=new(r-1,c-1)+2;
                    catch
                    end
                    try new(r-1,c)=new(r-1,c)+2;
                    catch
                    end
                    try new(r-1,c+1)=new(r-1,c+1)+2;
                    catch
                    end  
                    try new(r,c-1)=new(r,c-1)+2;
                    catch
                    end
                    try new(r,c+1)=new(r,c+1)+2;
                    catch
                    end
                    try new(r+1,c-1)=new(r+1,c-1)+2;
                    catch
                    end
                    try new(r+1,c)=new(r+1,c)+2;
                    catch
                    end
                    try new(r+1,c+1)=new(r+1,c+1)+2;
                    catch
                    end

                    % outer ring
                    try new(r-2,c-2)=new(r-2,c-2)+1;
                    catch
                    end
                    try new(r-2,c-1)=new(r-2,c-1)+1;
                    catch
                    end
                    try new(r-2,c)=new(r-2,c)+1;
                    catch
                    end
                    try new(r-2,c+1)=new(r-2,c+1)+1;
                    catch
                    end
                    try new(r-2,c+2)=new(r-2,c+2)+1;
                    catch
                    end
                    try new(r-1,c-2)=new(r-1,c-2)+1;
                    catch
                    end
                    try new(r-1,c+2)=new(r-1,c+2)+1;
                    catch
                    end
                    try new(r,c-2)=new(r,c-2)+1;
                    catch
                    end
                    try new(r,c+2)=new(r,c+2)+1;
                    catch
                    end
                    try new(r+1,c-2)=new(r+1,c-2)+1;
                    catch
                    end
                    try new(r+1,c+2)=new(r+1,c+2)+1;
                    catch
                    end
                    try new(r+2,c-2)=new(r+2,c-2)+1;
                    catch
                    end
                    try new(r+2,c-1)=new(r+2,c-1)+1;
                    catch
                    end
                    try new(r+2,c)=new(r+2,c)+1;
                    catch
                    end
                    try new(r+2,c+1)=new(r+2,c+1)+1;
                    catch
                    end
                    try new(r+2,c+2)=new(r+2,c+2)+1;
                    catch
                    end
                    new(r,c)=new(r,c)-32;
                end
            end
        end
        if edge==1
            frames=cat(3,frames,new);
        elseif edge==2
            frames{end+1}=new;
        end
    end
end
end