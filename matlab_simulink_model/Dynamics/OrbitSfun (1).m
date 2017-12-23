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

function [ xdot ] = OrbitModel( x,omega_orbit,wb_bi )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% state info

% current state vector

long=x(1);% From West to East (+-180) East is pos
lat=x(2);% From North to South (+-90deg) North is pos
Alt=x(3);

% quaternion rep rotation between body frame and orbit frame
q_o=x(4:7);
n_o=q_o(1);
eta_o=q_o(2:4);


%quat rep rotation between orbital frame and inertial frame
qoi=x(8:11);
n_oi=qoi(1);
eta_oi=qoi(2:4);



%% rotaton between frames

% between body and orbit frame
S_o=SkewSym(eta_o);
Ro_b=eye(3)+(2*n_o*S_o)+(2*(S_o^2));%from body to orbit frame
Rb_o=transpose(Ro_b);%from orbit to body frame


% define the angular velocity of the body frame wrt orbital frame.
omegab_ob=wb_bi-(Rb_o*(omega_orbit));
S_oi=SkewSym(eta_oi);

%% Differential Equations of Motion


%q meas wrt orbit frame
n_o_dot=-0.5*transpose(eta_o)*omegab_ob;
eta_o_dot=0.5*((n_o*eye(3))+S_o)*omegab_ob;
%q representing rotation between orbital n inertail frame
noidot=-0.5*transpose(eta_oi)*(omega_orbit);
etaoidot=0.5*((n_oi*eye(3))+S_oi)*(omega_orbit);

long_dot=omega_orbit(2);
lat_dot=sqrt((omega_orbit(1)^2)+(omega_orbit(3)^2));
Alt_dot=0;%const altitude

xdot=[long_dot;lat_dot;Alt_dot;n_o_dot;eta_o_dot;noidot;etaoidot];
