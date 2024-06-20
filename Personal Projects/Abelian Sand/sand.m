function frames=sand(in,edge)

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

while max(max(new))>3
    in=new;

    if edge==2
        edges=[in(1,:),in(end,:),in(:,1)',in(:,end)'];
        if max(edges)>3
            in=padarray(in,[1 1]);
            new=in;
        end
    end

    % If using falloff condition for edges of table, need to
    % account for critical points at pile corners and edges
    if edge==1
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
        frames=cat(3,frames,new);
    end

    if edge==2
        [row,col]=size(in);
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
        frames{end+1}=new;
    end

end

end