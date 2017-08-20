function [coeffs_N, SV_N] = SchmidtNormalization(N,M,coeffs,SV)

coeffs_N = coeffs;
SV_N = SV;

for i = 1:length(N)
    n = N(i); m = M(i);
    S = SchmidtQNormFactor(n,m);
    coeffs_N(i) = S * coeffs(i);
    SV_N(i) = S * SV(i);
end

return;