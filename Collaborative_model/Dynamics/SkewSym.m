function [ SSM ] = SkewSym( V )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
sign1=-1;
sign2=1;
SSM=zeros(length(V));
order=[2,1;3,1;3,2];
for i=1:length(V)
    SSM(order(i,2),order(i,1))=sign1*V(length(V)-i+1);
    SSM(order(i,1),order(i,2))=sign2*V(length(V)-i+1);
    sign1=sign1*-1;
    sign2=sign2*-1;
end

end

