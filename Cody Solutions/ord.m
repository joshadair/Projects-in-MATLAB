function s=ord(n) 

%negative=0;
%if n<=-1
%    n=abs(n);
%    negative=1;
%end

if n<=9
    temp=n;
else   
    temp=num2str(n)-'0'; 
    temp=polyval(temp(end-1:end),10);
    if ismember(temp,[10 11 12 13])==0 
        temp=num2str(n)-'0';
        temp=polyval(temp(end),10);
    end
end
    
switch temp       
    case 1          
        s=num2str(n)+"st";       
    case 2           
        s=num2str(n)+"nd";      
    case 3           
        s=num2str(n)+"rd";      
    otherwise
        s=num2str(n)+"th";
end
end