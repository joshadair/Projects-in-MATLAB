function output = checkermatrix(h,w,n)
output = zeros(h,w);

rsteps = h/n;
csteps = w/n;
block1 = ones(n);

% Creating "hollow" black boxes where black border remains with a white
% interior, used for experimenting with creating shadow effects by bluring
% the checkerboard setting as transparent overlay on image
block01 = block1;
block01(1,:,:) = 0;
block01(end,:,:) = 0;
block01(:,1,:) = 0;
block01(:,end,:) = 0;

for rstep=1:rsteps
    for cstep=1:csteps  
        if mod(rstep,2) == mod(cstep,2)        
            output(1+(rstep-1)*n:1+(rstep-1)*n+n-1,1+(cstep-1)*n:1+(cstep-1)*n+n-1) = block1;
        end
    end
end

end
        