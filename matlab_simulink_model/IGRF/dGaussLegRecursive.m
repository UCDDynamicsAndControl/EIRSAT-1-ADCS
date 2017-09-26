function P = dGaussLegRecursive(t,n,m)

%__________________________________________________________________________
% Recursive function to calculate derivatives of Gauss normalized Legendre 
% Polynomials. 
%__________________________________________________________________________


if m>n || n<0 || m<0
    P = 0;
elseif n == m
    P = sin(t)*dGaussLegRecursive(t,n-1,m-1) + ...
        cos(t)*GaussLegRecursive(t,n-1,m-1);
else 
    P = cos(t)*dGaussLegRecursive(t,n-1,m) - ...
        sin(t)*GaussLegRecursive(t,n-1,m) - ...
        Kfactor(n,m)*dGaussLegRecursive(t,n-2,m);
end

return;