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
        % perform smudge substitution at each possible node
        temp=a;
        if a(i2)=='.'
            temp(i2)='#';
        elseif a(i2)=='#'
            temp(i2)='.';
        end

        % test for lines of reflection after smudge substitution
        [altr,altc]=aoc23_13_2(temp);
        
        if isempty([altr,altc]) % no lines, try next smudge
            continue
        elseif length(altr)>1 || length(altc)>1 % multiple lines found (pre-smudge line of reflection is still present) 
            if all(altc==[0,0]) % both lines are horizontal, pick different row
                allaltr=[allaltr;setdiff(altr,r)];
                allaltc=[allaltc;0];
                break
            elseif all(altr==[0,0]) % both lines are horizontal, pick different column
                allaltr=[allaltr;0];
                allaltc=[allaltc;setdiff(altc,c)];
                break
            else % reflection line switched orientation, pick new pair (probably works for all cases)
                test=[altr;altc];
                test=test(test~=[r;c]);
                allaltr=[allaltr;test(1)];
                allaltc=[allaltc;test(2)];
                break
            end
        elseif ~isempty([altr,altc]) && any([altr,altc]~=[r,c]) % single reflection line found, not the same as original
            allaltr=[allaltr;altr];
            allaltc=[allaltc;altc];
            break
        elseif ~isempty([altr,altc]) % single reflection line found, same as original, store value, and continue iterating through smudges
            tempr=altr;
            tempc=altc;
        end

        if i2==numel(a) % at end of smudge subsitutitions, if no new reflection lines were found, triggering break(s), return repeat/original lines, if found
            allaltr=[allaltr;tempr];
            allaltc=[allaltc;tempc];
        end

    end
end

sol=sum(allaltr*100+allaltc); % weighted solution from problem statement

end