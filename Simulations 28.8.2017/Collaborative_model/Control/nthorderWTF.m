function [ G ] = nthorderWTF( w,n,varargin )
%Produces WTFs of order 2 or higher
%   NTHORDERWTF  is used to produce approximations of the wave transfer 
%   of a system with natural frequency w. The approximations produced may
%   be 2nd order or higher. 
%   
%   second order WTFs are based on a mass-spring-damper system with half
%   critical damping. An itterative method is used to approximate higher
%   order WTFs. 
%
%   the input w is the frequency of the 2nd order WTF. the input n
%   determins the order of the WTF. 
%   n = 1 returns a second order WTF.
%   n > 2 returns higher order WTFs.
if length(varargin)==1
    wtfDampingRatio=varargin{1};
else
    wtfDampingRatio=0.5;
end

s=tf('s');

if n>1 %Preoduce higher order G
    w=w*sqrt(2);
    G=(w^2)/((s^2)+(2*wtfDampingRatio*w*s)+(w^2));
    w=w/sqrt(2);
    for i=2:n
        G1=(0.5*(1-(G^2))/(1-G+(0.5*((s/w)^2))));
        G=minreal(G1,[],false);
    end
else 
    G=(w^2)/((s^2)+(2*wtfDampingRatio*w*s)+(w^2));
end




end

