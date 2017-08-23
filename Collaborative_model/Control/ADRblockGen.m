function [ ADR_block ] = ADRblockGen(w,I,order)
%Create the transfer function used to reject disturbances from WBC
%systems
%   Produce a transfer function based on a state observer which is used for 
%   active disturbance rejection. For inputs, returned the transfer 
%   function takes the plant input and output. the output of the TF is the
%   estimate of the distrubing force acting on the plant.
%
%   ADR_block = ADRBLOCKGEN( w, I, order)
%
%   The TF produced, ADR_block, from the example above will be based on a 
%   state observer of the specified order and with negative real poles of 
%   frequency w. The TF can be used to reject distrubances from a system 
%   with an inertia of I.
%
%   This observer models the plant as a single mass with a force input and
%   a position output. Anything which accelerates the plant other than the
%   input force is considered a disturbance
%   
%   An nth order TF prodecued by ADRBLOCKGEN will be of the following form:
%
%                   L(3)s^(n-3)+L(4)s^(n-4)+...+L(n)
%   F_dist_est = --------------------------------------- * [((Y/b)*s^2)-U]
%                s^n+L(1)s^(n-1)+L(2)s^(n-2)+.....+L(n)
%
%   Where Y & U are the measured output position and measured input force 
%   in the complex frequency domain. b is a ADR parameter and is equal to 
%   1/I, the vector L contains the state observer gains which are the 
%   coefficient of the polynomial (s+w)^(order).
%


[L,b]=ESOvalues(w,I,order);%find L and b
A=tf(L(3:end),[1,L]);%calculate the TF which ensures the ADR transfer funct remains proper
s=tf('s');

%input 1 = plant output position
%input 2 = plant input

ADR_block(1)=(A*(s^2))/b;
ADR_block(2)=-A;

end

