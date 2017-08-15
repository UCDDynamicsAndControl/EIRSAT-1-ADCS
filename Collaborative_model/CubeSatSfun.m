function CubeSatSfun(block)
%MSFUNTMPL_BASIC A Template for a Level-2 MATLAB S-Function
%   The MATLAB S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl_basic' with the 
%   name of your S-function.

setup(block);

%endfunction

function setup(block)

% Register parameters
block.NumDialogPrms=3;

% Register number of ports
block.NumInputPorts  = 1;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
block.InputPort(1).Dimensions        = 3;
block.InputPort(1).DirectFeedthrough = false;

% Override output port properties
block.OutputPort(1).Dimensions       = 18;

block.SampleTimes = [0 0];%continuous sample time
block.NumContStates=18;
block.SimStateCompliance = 'DefaultSimState';

block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Outputs', @Outputs);    
block.RegBlockMethod('Derivatives', @Derivatives);
%end setup

function InitializeConditions(block)
block.ContStates.Data=block.DialogPrm(1).Data;

%end InitializeConditions


function Outputs(block)
block.OutputPort(1).Data=block.ContStates.Data;
%end Outputs

function Derivatives(block)
I=block.DialogPrm(2).Data;
omega_orbit=block.DialogPrm(3).Data;
T=block.InputPort(1).Data;
block.Derivatives.Data=CubeSatModel(block.ContStates.Data,I,omega_orbit,T);
%end Derivatives
