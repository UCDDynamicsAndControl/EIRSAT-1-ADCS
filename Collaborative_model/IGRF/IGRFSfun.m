function IGRFSfun(block)
%MSFUNTMPL_BASIC A Template for a Level-2 MATLAB S-Function
%   The MATLAB S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl_basic' with the 
%   name of your S-function.

setup(block);

%endfunction

function setup(block)

% Register parameters
block.NumDialogPrms = 4;

% Register number of ports
block.NumInputPorts  = 2;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
block.InputPort(1).Dimensions = 3;
block.InputPort(2).Dimensions = 1;
block.InputPort(1).DirectFeedthrough = false;

% Override output port properties
block.OutputPort(1).Dimensions = 3;

block.SampleTimes = [0 0];%continuous sample time
block.SimStateCompliance = 'DefaultSimState';

block.RegBlockMethod('Outputs', @Outputs);    
%end setup

function Outputs(block)
LLA = block.InputPort(1).Data; % long, lat, alt
LST = block.InputPort(2).Data; % Local Sidereal Time
lon = LLA(1);
lat = LLA(2);
alt = LLA(3);
<<<<<<< HEAD:Collaborative_model/IGRF11Sfun.m
n=block.DialogPrm(1).Data;
m=block.DialogPrm(2).Data;
tol=block.DialogPrm(3).Data;
Re=block.DialogPrm(4).Data;
COEFS=block.DialogPrm(5).Data;
FRAME=block.DialogPrm(6).Data;
block.OutputPort(1).Data=IGRF11(lon,lat,alt,n,m,tol,Re,COEFS,FRAME);
=======
L=block.DialogPrm(1).Data;
tol=block.DialogPrm(2).Data;
G_COEFS=block.DialogPrm(3).Data;
H_COEFS=block.DialogPrm(4).Data;
block.OutputPort(1).Data=IGRF(lat,lon,alt,L,tol,G_COEFS,H_COEFS,LST);
>>>>>>> master:Collaborative_model/IGRF/IGRFSfun.m
%end Outputs
