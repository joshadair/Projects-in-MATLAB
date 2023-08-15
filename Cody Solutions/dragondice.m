function [rolls, prob_win] = dragondice(x,y,n)
prob_win = [];
trial = 1;
for x=x
    rolls = zeros(n,3,length(x));
    me = [];
    dragon = 0;

    for i=1:n   
        me = randi(y,1,x/y); 
        tot = sum(me);
        rolls(i,1,trial) = tot;
        
        dragon = randi(x);      
        rolls(i,2,trial) = dragon;
    
        if sum(me)>=dragon       
            rolls(i,3,trial) = 1;  
        else            
            rolls(i,3,trial) = 0;    
        end 
       
    end     
    prob_win(end+1) = sum(rolls(:,3,trial))/n;
    trial = trial+1;
end

end

     
    