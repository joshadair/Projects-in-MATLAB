function ans = has_doughnut2(x)

if      ~x(1,:)
    x(1,:) = [];
end
if  ~x(:,1)
    x(:,1) = [];
end
if   ~x(end,:)
    x(end,:) = [];
end
if  ~x(:,end)
    x(:,end) = [];
end

sum(x);

all(ans>1) & sum(ans>2)>1;