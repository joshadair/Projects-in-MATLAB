function [sol,allr,allc,allaltr,allaltc]=aoc23_13_2solve(in)
allr=[];
allc=[];
allaltr=[];
allaltc=[];
out=aoc23_13_aux(in); % turns raw input data into cell of separate diagrams

for i1=1:length(out)
    a=out{i1};
    [r,c]=aoc23_13_1(a); % get value of line of reflection (vertical:[r=0,c=#] horiztonal[r=#,c=0])
    allr=[allr;r];
    allc=[allc;c];
    tempr=0;
    tempc=0;
    for i2=1:numel(a)
        temp=a;
        if a(i2)=='.'
            temp(i2)='#';
        elseif a(i2)=='#'
            temp(i2)='.';
        end
        [altr,altc]=aoc23_13_1(temp);
        if ~all([altr,altc]==[0,0]) && any([altr,altc]~=[r,c])
            allaltr=[allaltr;altr];
            allaltc=[allaltc;altc];
            break
        elseif ~all([altr,altc]==[0,0])
            tempr=altr;
            tempc=altc;
        end

        if i2==numel(a)
            allaltr=[allaltr;tempr];
            allaltc=[allaltc;tempc];
        end

    end
end

sol=sum(allaltr*100+allaltc); % weighted from problem statement

end