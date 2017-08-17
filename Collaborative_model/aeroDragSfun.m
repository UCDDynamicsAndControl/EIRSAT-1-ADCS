function aeroDragSfun(block)
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
block.NumInputPorts  = 3;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
block.InputPort(1).Dimensions = 3;
block.InputPort(2).Dimensions = 3;
block.InputPort(3).Dimensions = 1;
block.InputPort(1).DirectFeedthrough = false;
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
qb_o = block.InputPort(1).Data;
omega_orbit = block.InputPort(2).Data;
vel=block.InputPort(3).Data;
I=block.DialogPrm(1).Data;
mass=block.DialogPrm(2).Data;
c_p=block.DialogPrm(3).Data;
A_d=block.InputPort(4).Data;
block.OutputPort(1).Data=aeroDrag(qb_o,omega_orbit,vel,I,mass,c_p,A_d);
%end Outputs

function Derivatives(block) %We do not have derivatives
%end Derivatives
