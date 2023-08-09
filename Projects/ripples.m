function [initial,final,iterations] = ripples(n,pebbles)
final = zeros(n);
locs_pebbles = randperm(n^2,pebbles);
final(locs_pebbles) = 2;
%prev_locs = zeros(n,n,2);
iterations = {};
initial = final;

while (find(final==2) > 0 & length(iterations) < 100)
    %prev_locs = padarray(prev_locs,[1 1]);
    final = padarray(final,[1 1]);
    [row_i2,col_i2] = find(final==2);   
    
    for x = 1:length(row_i2)
        r=row_i2(x);
        c=col_i2(x);
        
        [nhood2_r,nhood2_c] = find(final(r-1:r+1,c-1:c+1)<2);
        
        for y=1:length(nhood2_r)                        
            final(nhood2_r(y)+r-2,nhood2_c(y)+c-2) = final(nhood2_r(y)+r-2,nhood2_c(y)+c-2) + 1;
        end
        
        %output(r-1:r+1,c-1:c+1) = output(r-1:r+1,c-1:c+1) + 1;
        %prev_locs(r-1:r+1,c-1:c+1,1) = r;
        %prev_locs(r-1:r+1,c-1:c+1,1) = c;
        
    end
    
    final(row_i2,col_i2) = 0;
    
    
   % [row_i1,col_i1] = find(output==1);    
   % for x = 1:length(row_i1)
      %  r=row_i1(x);
       % c=col_i1(x);
       
       
    final = final(2:end-1,2:end-1);
    %prev_locs = prev_locs(2:end-1,2:end-1);
    iterations{end+1} = final;       
end

end

