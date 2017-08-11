function Y = discreteLPfilter(Y_prev,X,cutoff,sampl)

%__________________________________________________________________________
%
% discreteLPfilter dicrete low-pass filter.
%
% Exponentially weighted moving average. Uses a backwards finite difference
% formula to estimate the derivative.
% The finite difference formula must be backwards since future states of 
% the magnetic field vector are unknown.
%
% Y = discreteLPfilter(Y_prev,X,cutoff,sampl_rate)
%   Returns the filtered value of the output Y.
%   * Y_prev is the state of the filtered signal at step k-1.
%   * X is the measured state at step k.
%   * cutoff is the cut-off frequency  (Hz)
%   * sampl is the sample rate (Hz)
%
%__________________________________________________________________________

c = 2*pi*cutoff/sampl;
a = 1/(1+c);
b = c * a;

Y = a*Y_prev + b*X;

return;