function [rolls, prob_win] = dragondice(x,y,n)   
rolls = zeros(n,3);     

for trial=1:n          
    me = randi(y,1,x/y); 
    my_total = sum(me);
    rolls(trial,1) = my_total; 
    dragon = randi(x,1);
    rolls(trial,2) = dragon;   
    
    if my_total>=dragon                  
        rolls(trial,3) = 1;         
    else       
        rolls(trial,3) = 0;       
    end    
end
prob_win = sum(rolls(:,3))/n;   

end

     
    