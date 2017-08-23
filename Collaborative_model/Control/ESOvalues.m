function [L,b] = ESOvalues( w_obs,I,order)
%Calculates Parameters for ADR
%   Produces observer gains L, and parameter b for use in a WBC system with 
%   active disturbance rejection.
%   
%   [L,b]=ESOVALUES(w_obs,I,order)
%   
%   The above produces the vector of observer gains L and the parameter b.
%   the observer gains are chosen to be the coefficients of the polynomial:
%   (s+w_obs)^(order).
%   this method of chosing gains is used as it is simple and ensures all
%   observer poles are stable.

% calculate the observer gains symbolicaly.
w_obs_sym=sym(w_obs); 
order_sym=sym(order);
syms s;%complex frequency variable
gain_polynomial=expand((s+w_obs_sym)^order_sym);
poly_coeffs=coeffs(gain_polynomial);
Gains=double(poly_coeffs);
Gains=fliplr(Gains);% the coefficients will be listed the wrong way around, flip them
L=Gains(2:end);%the first coefficient will be a 1, this isnt used.

b=1/I;%the ADR parameter b is ithe inverse of the plant inertia

end

