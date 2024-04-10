function Z = dda(X,Y)
   X=X-'0';
   Y=Y-'0';
   
   if length(X)>length(Y)
       Y=[zeros(1,length(X)-length(Y)) Y]; 
       Z=X+Y;
   elseif length(X)<length(Y)
       X=[zeros(1,length(Y)-length(X)) X];
       Z=X+Y;
   else
       Z=X+Y;  
   end
   
   while any(Z>9)
   for i1=length(Z):-1:1
       if Z(i1)>9 && i1~=1
           Z(i1-1)=Z(i1-1)+floor(Z(i1)/10);
           Z(i1)=mod(Z(i1),10);
       elseif Z(i1)>9
           Z=[floor(Z(i1)/10) Z];
           Z(2)=mod(Z(2),10);
       end
   end
   end

   Z=mat2str(Z);
   Z=Z(2:end-1);
   Z(Z==' ')='';
  
   
end
