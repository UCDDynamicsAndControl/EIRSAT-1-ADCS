function OrbitSfun(block)
%MSFUNTMPL_BASIC A Template for a Level-2 MATLAB S-Function
%   The MATLAB S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl_basic' with the 
%   name of your S-function.

setup(block);

%endfunction

function setup(block)

% Register parameters
block.NumDialogPrms=2;

% Register number of ports
block.NumInputPorts  = 1;
block.NumOutputPorts = 3;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
block.InputPort(1).Dimensions=3;
block.InputPort(1).DataTypeId=0;
block.InputPort(1).DirectFeedthrough=false;
block.InputPort(1).SamplingMode='Sample';
block.InputPort(1).Complexity='Real';

% Override output port properties
block.OutputPort(1).Dimensions = 3;
block.OutputPort(1).SamplingMode='Sample';
block.OutputPort(2).Dimensions = 4;
block.OutputPort(2).SamplingMode='Sample';
block.OutputPort(3).Dimensions = 4;
block.OutputPort(3).SamplingMode='Sample';

block.SampleTimes = [0 0];%continuous sample time
block.NumContStates=11;
block.SimStateCompliance = 'DefaultSimState';

block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Outputs', @Outputs);    
block.RegBlockMethod('Derivatives', @Derivatives);
%end setup

function InitializeConditions(block)
x_init=block.DialogPrm(1).Data;
block.ContStates.Data=x_init;

%end InitializeConditions


function Outputs(block)
block.OutputPort(1).Data=block.ContStates.Data(1:3);
block.OutputPort(2).Data=block.ContStates.Data(4:7);
block.OutputPort(3).Data=block.ContStates.Data(8:11);

%end Outputs

function Derivatives(block)

omega_orbit=block.DialogPrm(2).Data;
wb_bi=block.InputPort(1).Data;
block.Derivatives.Data=OrbitModel(block.ContStates.Data,omega_orbit,wb_bi);
%end Derivatives
