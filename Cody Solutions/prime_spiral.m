function d = prime_spiral(n)
matrix = spiral(n);
p_matrix = isprime(matrix);
p_matrix = [zeros(1,n); p_matrix; zeros(1,n)];
p_matrix = [zeros(n+2,1), p_matrix, zeros(n+2,1)];
test_all = [1 0 1; 0 0 0 ; 1 0 1];
test_1 = [1 0 0; 0 0 0; 0 0 0];
test_3 = [0 0 0; 0 0 0; 1 0 0];
test_7 = [0 0 1; 0 0 0; 0 0 0];
test_9 = [0 0 0; 0 0 0; 0 0 1];

d = 1;

for r=2:n+1
    for c=2:n+1
        if p_matrix(r,c) == 1
            nhood_matrix = p_matrix(r-1:r+1,c-1:c+1);
           
            if sum(sum(test_all .* nhood_matrix)) > 0              
                new_nhood_matrix = nhood_matrix;              
                test_d = 1;
                new_r = r;
                new_c = c;
                while sum(sum(test_1 .* new_nhood_matrix)) > 0 
                   test_d = test_d + 1;
                   new_r = new_r-1; 
                   new_c = new_c-1;                 
                   new_nhood_matrix = p_matrix(new_r-1:new_r+1,new_c-1:new_c+1);               
                end                                
                if test_d > d                 
                    d = test_d;              
                end
                
                new_nhood_matrix = nhood_matrix;
                test_d = 1;
                new_r = r;
                new_c = c;
                while sum(sum(test_3 .* new_nhood_matrix)) > 0 
                    test_d = test_d + 1;
                    new_r = new_r+1;                  
                    new_c = new_c-1;                      
                    new_nhood_matrix = p_matrix(new_r-1:new_r+1,new_c-1:new_c+1);               
                end                
                if test_d > d
                    d = test_d;              
                end
                
                new_nhood_matrix = nhood_matrix;
                test_d = 1;  
                new_r = r;
                new_c = c;
                while sum(sum(test_7 .* new_nhood_matrix)) > 0    
                    test_d = test_d + 1;
                    new_r = new_r-1;                  
                    new_c = new_c+1;
                    new_nhood_matrix = p_matrix(new_r-1:new_r+1,new_c-1:new_c+1);     
                end
                if test_d > d
                    d = test_d;              
                end
                
                
                new_nhood_matrix = nhood_matrix;
                test_d = 1; 
                new_r = r;
                new_c = c;
                while sum(sum(test_9 .* new_nhood_matrix)) > 0                  
                    test_d = test_d + 1;
                    new_r = new_r+1;                 
                    new_c = new_c+1;
                    new_nhood_matrix = p_matrix(new_r-1:new_r+1,new_c-1:new_c+1);                               
                end   
                if test_d > d
                    d = test_d;              
                end                           
            end
            
            p_matrix(r,c) = 0;
        end
    end
end
                
        
        
end