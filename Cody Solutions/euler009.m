function [y,a1,b,c] = euler009(x)
syms s c
s= 0==(x^2*c)/2-x*c^2;
sols=double(solve(s,c));
sol=sols(sols>0);
for c=floor(sol):-1:1
    for b=c-1:-1:1
        a1=(c^2-b^2)^(1/2);
        a2=x-b-c;
        if a1==a2 && mod(a1,1)==0
            y=a1*b*c;
            return
        end
    end
end
   
end