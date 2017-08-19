function [P,dP] = legendreRecursive(x,cosx,sinx,n,m)

%__________________________________________________________________________
% Recursive function to calculate Legendre Polynomials. 
% sin(x) and cos(x) are calculated beforehand, so they are passed as
% arguments, instead of calculated inside the funcion.
%__________________________________________________________________________


if (n~=0 || m~=0) && (n~=1 || m~=1) && n>=0 && m>=0 
    if n ~= m % Recursive case
    [P1,dP1] = legendreRecursive(x,sinx,cosx,n-1,m); 
    [P2,dP2] = legendreRecursive(x,sinx,cosx,n-2,m);
    P = (2*n-1)/sqrt(n^2-m^2)*cosx * P1 - sqrt(((n-1)^2-m^2)/(n^2-m^2)) * P2;
    dP = (2*n-1)/sqrt(n^2-m^2)*(cosx*dP1 - sinx*P1) - sqrt(((n-1)^2-m^2)/(n^2-m^2))*dP2;
    else % Recursive Case 
    [P11,dP11] = legendreRecursive(x,sinx,cosx,n-1,m-1);
    P = sqrt(1-1/(2*n))*sinx*P11;
    dP = sqrt(1-1/(2*n))*(sinx*dP11 + cosx*P11);
    end
elseif n <= 0 && m <= 0 % Base Case
    P = 1;
    dP = 0;
elseif n == 1 && m == 1 % Base Case
    P = sinx;
    dP = cosx;
elseif n < 0 || m < 0
    P = 0;
    dP = 0;
end
    

