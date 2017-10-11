function [G,H] = loadIGRFCoeffs(struc)

%__________________________________________________________________________
% 
% This function takes the gaussian normalized coefficients from the structure 
% struc, normalizes them, according to the Schmidt
% quasi-normalization. It stores g_n^m and h_n^m in the matrices G and H,
% with n going down the rows and m through the columns. 
% Mind the offset in m. m starts at 0, thus, the entry G(i,j) and H(i,j) 
% correspond to g_i^{j-1} and h_i^{j-1}, respectively. e.g. G(1,3) = g_1^2
%
%--------------------------------------------------------------------------
% The structure struc consist of 5 vectors:
%   - struc.gh = ['g' 'g' 'h' 'g'...] 
%   - struc.n = [1 1 1 2 ...]
%   - struc.m = [0 1 1 0 1 ...]
%   - struc.coeffs = [-29619.4, -1728.2,...] the set of coefficients before
%       Schmidt quasi-normalization
%   - struc.SV = [-29619.4, -1728.2,...] the set of Secular Variation 
%       coefficients before Schmidt quasi-normalization
%
% (See J.Davis- Mathematical modelling of Earth's magnetic field. pg 16,17)
%
% -------------------------------------------------------------------------
% 
% The point of this is to be able to get the coefficients (already
% normalized) in matrix form, from any set of IGRF coefficients, if an
% structure is the described form is available.
%
%__________________________________________________________________________


N = struc.n;
M = struc.m;
gh = struc.gh;
coeffs = struc.coeffs;
SV = struc.SV;

nmax = N(length(N));
mmax = M(length(M));
G = zeros(nmax,mmax+1);
H = G;

for i = 1:length(N)
    n = N(i); m = M(i);
    S = SchmidtQNormFactor(n,m);
    normCoef = S * coeffs(i);  % Normalize the coefficient
    normSV = S * SV(i); % Normalize the secular variation
    if strcmp(gh(i),'g') % if it is a g, store the coefficient in G matrix
        G(n,m+1) = normCoef; % mind the offset in m
    elseif strcmp(gh(i),'h') % if it is an h, store the coefficient in H matrix
        H(n,m+1) = normCoef; % mind the offset in m
    end
end

return;
