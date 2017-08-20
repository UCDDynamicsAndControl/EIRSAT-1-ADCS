function P = GaussLegRecursive(t,n,m)

%__________________________________________________________________________
% Recursive function to calculate Gauss normalized Legendre Polynomials. 
%__________________________________________________________________________


if m>n || n<0 || m<0
    P = 0;
elseif n == 0 && m == 0;
    P = 1;
elseif n == m
    P = sin(t)*GaussLegRecursive(t,n-1,m-1);
else 
    P = cos(t)*GaussLegRecursive(t,n-1,m) - Kfactor(n,m)*GaussLegRecursive(t,n-2,m);
end

return;