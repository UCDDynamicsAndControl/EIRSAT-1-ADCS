function S = SchmidtQNormFactor(n,m)

if n == 0 && m == 0
    S = 1;
elseif n ~= 0 && m == 0
    S = SchmidtQNormFactor(n-1,m)*(2*n-1)/n;
else
    S = SchmidtQNormFactor(n,m-1) * ...
        sqrt((n-m+1)*(delta(m,1)+1)/(n+m));
end
return;

function d = delta(a,b)
if a ~= b
    d = 0;
else
    d = 1;
end
return;