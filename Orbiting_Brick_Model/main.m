clear all; 
% close all; 
clc;
%Run Setup
CubeQuat_setup;

k_realm = 10000;
%Run simulation
sim('CubeQuat.slx');

%Graphics and plots
graphics;