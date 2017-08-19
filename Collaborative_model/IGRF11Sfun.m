function IGRF11Sfun(block)
%MSFUNTMPL_BASIC A Template for a Level-2 MATLAB S-Function
%   The MATLAB S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl_basic' with the 
%   name of your S-function.

setup(block);

%endfunction

function setup(block)

% Register parameters
block.NumDialogPrms = 5;

% Register number of ports
block.NumInputPorts  = 1;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
block.InputPort(1).Dimensions = 3;
block.InputPort(1).DirectFeedthrough = false;

% Override output port properties
block.OutputPort(1).Dimensions = 3;

block.SampleTimes = [0 0];%continuous sample time
block.NumContStates=18;
block.SimStateCompliance = 'DefaultSimState';

block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Outputs', @Outputs);    
block.RegBlockMethod('Derivatives', @Derivatives);
%end setup
 
function InitializeConditions(block) %Nothing to initialize
%end InitializeConditions


function Outputs(block)
LLA = block.InputPort(1).Data;
lon = LLA(1);
lat = LLA(2);
alt = LLA(3);
L=block.DialogPrm(1).Data;
tol=block.DialogPrm(2).Data;
Re=block.DialogPrm(3).Data;
COEFS=block.DialogPrm(4).Data;
FRAME=block.DialogPrm(5).Data;
block.OutputPort(1).Data=IGRF11(lat,lon,alt,L,tol,Re,COEFS,FRAME);
%end Outputs

function Derivatives(block) %We do not have derivatives
%end Derivatives
