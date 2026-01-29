function [count,lines]=aoc16_7_a()
lines={};
count=0;
filename='C:\Users\weaze\GitHub\Projects-in-MATLAB\Advent of Code\2016\day7.txt';
t=readtable(filename,'ReadVariableName',false);
for i1=1:height(t)
   line=t.Var1{i1};
   ishypernet=0;
   supportsTLS=0;
   for i2=1:length(line)-3
       active=line(i2);
       
       if active=='['
           ishypernet=1;
           continue
       elseif active==']'
           ishypernet=0;
           continue 
       end
       
       pair1=line(i2:i2+1);
       pair2=line(i2+2:i2+3);
       
       if any(pair1=='[') || any(pair2=='[') || any(pair1==']') || any(pair2==']')
           continue   
       elseif strcmp(pair1,flip(pair2)) && ~strcmp(pair1,pair2)
           if ishypernet==1
               supportsTLS=0;
               break
           else
               supportsTLS=1;
           end
       end      
   end 
   
   if supportsTLS==1
       lines{end+1}=line;
       count=count+1;
   end
   
end
lines=transpose(lines);
end
