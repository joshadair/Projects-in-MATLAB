function [count,lines]=aoc16_7_b()
lines={};
count=0;
filename='C:\Users\weaze\GitHub\Projects-in-MATLAB\Advent of Code\2016\day7.txt';
t=readtable(filename,'ReadVariableName',false);
for i1=1:height(t)
    line=t.Var1{i1};
    snet={};
    hnet={};
    oBrack=find(line=='[');
    cBrack=find(line==']');
    for i2=1:length(oBrack)
        if i2==1
            snet{end+1}=line(1:oBrack(i2)-1);
            hnet{end+1}=line(oBrack(i2)+1:cBrack(i2)-1);
        else
            snet{end+1}=line(cBrack(i2-1)+1:oBrack(i2)-1);
            hnet{end+1}=line(oBrack(i2)+1:cBrack(i2)-1);
        end
        
        if i2==length(oBrack)
            snet{end+1}=line(cBrack(i2)+1:end);
        end
        
    end
    
    % are supernets the entire sequence of characters outside of brackets,
    % forming what would be a single, superstring with the entirety of
    % characters inside brackets being a separate, single, hyperstring
    %
    % this definition calls into question the boundary cases. for example in
    % the first line: 'xdsqxnovprgovwzkus[fmadbfsbqwzzrzrgdg]aeqornszgvbizdm'
    %
    % can the last two characters before the '[' combine with the first
    % character after the ']' to form a triple (same with multiple [] groups).
    % basically do the groups get combined into one string or treated as
    % separate groups
    
    snet=strjoin(snet,'');
    hnet=strjoin(hnet,'');
    
    for i3=1:length(snet)-2
        aba=snet(i3:i3+2);
        if aba==flip(aba);
            bab='';
            bab(end+1)=aba(2);
            bab(end+1)=aba(1);
            bab(end+1)=aba(2);
            if strfind(hnet,bab)==true
            count=count+1;
            lines{end+1}=line;
            end
        end
    end
end
end
