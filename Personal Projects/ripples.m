function [in,fin,iterations]=ripples(n,pebbles)
fin=zeros(n);
dir=fin;
locs_pebbles=randperm(n^2,pebbles);
fin(locs_pebbles)=2;
iterations={};
iterations{end+1}=fin;

while (numel(find(fin>0))>0 & length(iterations)<48)
    [x_pebs,y_pebs]=find(fin>1);
    for i1=1:length(x_pebs)
        r=x_pebs(i1);
        c=y_pebs(i1);
        if dir(r,c)=='p'
            fin(r-1,c-1)=fin(r-1,c-1)+1;
            dir(r-1,c-1)='nw';
            fin(r-1,c)=fin(r-1,c)+1;
            dir(r-1,c)='n';
            fin(r-1,c+1)=fin(r-1,c+1)+1;
            dir(r-1,c+1)='ne';
            fin(r,c-1)=fin(r,c-1)+1;
            dir(r,c-1)='w';
            fin(r,c+1)=fin(r,c+1)+1;
            dir(r,c+1)='e';
            fin(r+1,c-1)=fin(r+1,c-1)+1;
            dir(r+1,c-1)='sw';
            fin(r+1,c)=fin(r+1,c)+1;
            dir(r+1,c)='s';
            fin(r+1,c+1)=fin(r+1,c+1)+1;
            dir(r+1,c+1)='se';
            fin(r,c)=fin(r,c)-2;
            dir(r,c)='d';
        else
            continue;
        end
    end

    [x_rips,y_rips]=find(fin>0);
    for i1=1:length(x_rips)
        r=x_rips(i1);
        c=y_rips(i1);

        if r==1 || r==n || c==1 || c==n
            `

        end





        dir_peb=dir(r,c);
        switch dir_peb
            case 'n'
                if r==1

                else
                    fin(r-1,c)=fin(r-1,c)+1;
                    dir(r-1,c)=dir_peb;

                end
            case 'e'
                if c==col

                else
                    fin(r,c+1)=fin(r,c+1)+1;
                    dir(r,c+1)=dir_peb;

                end
            case 's'
                if r==row

                else
                    fin(r+1,c)=fin(r+1,c)+1;
                    dir(r+1,c)=dir_peb;
                end
            case 'w'
                if c==1

                else
                    fin(r,c-1)=fin(r,c-1)+1;
                    dir(r,c-1)=dir_peb;
                end
            case 'ne'
                if r==1 || c==1

                else
                    fin(r-1,c+1)=fin(r-1,c+1)+1;
                    dir(r-1,c+1)=dir_peb;
                end
            case 'se'
                if r==row || c==col

                else
                    fin(r+1,c+1)=fin(r+1,c+1)+1;
                    dir(r+1,c+1)=dir_peb;
                end
            case 'sw'
                if r==row || c==1

                else
                    fin(r+1,c-1)=fin(r+1,c-1)+1;
                    dir(r+1,c-1)=dir_peb;
                end
            case 'nw'
                if r==1 || c==1

                else
                    fin(r-1,c-1)=fin(r-1,c-1)+1;
                    dir(r-1,c-1)=dir_peb;
                end
            otherwise


        end

        fin(r,c)=fin(r,c)-1;
    end

    fin(row_i2,col_i2) = 0;


    % [row_i1,col_i1] = find(output==1);
    % for x = 1:length(row_i1)
    %  r=row_i1(x);
    % c=col_i1(x);


    fin = fin(2:end-1,2:end-1);
    %prev_locs = prev_locs(2:end-1,2:end-1);
    iterations{end+1} = fin;
end

end

