function K = Kfactor(n,m)

%__________________________________________________________________________
% K(n,m) factors used in the computation of Gauss-Normalized Legendre
% Polynomials
%__________________________________________________________________________

if n < 1;
    error(' n must be greater than 1')
end

if n == 1;
    K = 0;
else 
    K = ((n-1)^2-m^2)/((2*n-1)*(2*n-3));
end

return;