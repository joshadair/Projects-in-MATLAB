function tf = islychrel(n)
tf=true;
for i=1:50
    n=str2double(flip(num2str(n,100)))+n;
    if isequal(n,str2double(flip(num2str(n,100))))
        tf=false;
        return;
    end    
end