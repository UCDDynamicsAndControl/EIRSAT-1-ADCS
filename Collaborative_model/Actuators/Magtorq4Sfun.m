function Magtorq4Sfun(block)
%MSFUNTMPL A Template for a MATLAB S-Function

setup(block);
  
%endfunction

function setup(block)

  block.NumDialogPrms = 3;
  % Register the number of ports.
  block.NumInputPorts  = 3;
  block.NumOutputPorts = 3;
  
  % Set up the port properties to be inherited or dynamic.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;

  % Override the input port properties.
  block.InputPort(1).DatatypeID  = 0;  % double
  block.InputPort(1).Complexity  = 'Real';
  block.InputPort(1).Dimensions  = 3;
  block.InputPort(1).DirectFeedthrough = false;
  block.InputPort(1).SamplingMode='Sample';
  
  block.InputPort(2).DatatypeID  = 0;  % double
  block.InputPort(2).Complexity  = 'Real';
  block.InputPort(2).Dimensions  = 3;
  block.InputPort(2).DirectFeedthrough = false;
  block.InputPort(2).SamplingMode='Sample';
  
  block.InputPort(3).DatatypeID  = 0;  % double
  block.InputPort(3).Complexity  = 'Real';
  block.InputPort(3).Dimensions  = 3;
  block.InputPort(3).DirectFeedthrough = false;
  block.InputPort(3).SamplingMode='Sample';
  
  % Override the output port properties.
  block.OutputPort(1).DatatypeID  = 0; % double
  block.OutputPort(1).Complexity  = 'Real';
  block.OutputPort(1).Dimensions  = 3;
  block.OutputPort(1).SamplingMode='Sample';
  
  block.OutputPort(2).DatatypeID  = 0; % double
  block.OutputPort(2).Complexity  = 'Real';
  block.OutputPort(2).Dimensions  = 3;
  block.OutputPort(2).SamplingMode='Sample';
  
  block.OutputPort(3).DatatypeID  = 0; % double
  block.OutputPort(3).Complexity  = 'Real';
  block.OutputPort(3).Dimensions  = 3;
  block.OutputPort(3).SamplingMode='Sample';
 

  block.SampleTimes = [0 0];
  
  % -----------------------------------------------------------------
  % Options
  % -----------------------------------------------------------------
  % Specify if Accelerator should use TLC or call back to the 
  % MATLAB file
  block.SetAccelRunOnTLC(false);
  

  block.SimStateCompliance = 'DefaultSimState';


  block.RegBlockMethod('Outputs', @Outputs);


%endfunction

% -------------------------------------------------------------------
% The local functions below are provided to illustrate how you may implement
% the various block methods listed above.
% -------------------------------------------------------------------


function Outputs(block)
  nAx = block.DialogPrm(1).Data; % Coils data
  nAy = block.DialogPrm(2).Data;
  nAz = block.DialogPrm(3).Data;
  T_spec=block.InputPort(1).Data;%torque specified by controller
  B_real=block.InputPort(2).Data;%actual B vector
  B_meas=block.InputPort(3).Data;%measured B vector
  nA = [nAx,nAy,nAz];
  [m_b,T_act,i] = Magtorq4(B_meas,B_real,T_spec,nA);
  block.OutputPort(1).Data = T_act; % actuator torque
  block.OutputPort(2).Data = m_b; % magnetic dipole
  block.OutputPort(3).Data = i; % Current
%endfunction

function [m_b,T_act,i] = Magtorq4(B_meas,B_real,T_spec,nA)
i = zeros(3,1);
if norm(T_spec) < 1e-20; T_spec = [1,1,1]*1e-20; end % Avoid singularity
e_m = cross(B_meas,T_spec)/(norm(B_meas)*norm(T_spec)); % unit vector in the direction of the dipole
e_c = cross(B_meas,e_m)/norm(B_meas); % Unit vector in the direction we will apply torque
T_act_meas = dot(T_spec,e_c)*e_c; % Projection into the B normal plane (measured B)
m_b = cross(B_meas,T_act_meas)/(norm(B_meas)^2); % Required dipole (measured B)
T_act = cross(m_b,B_real); % Actual produced torque
i(1) = m_b(1)/nA(1); i(2) = m_b(2)/nA(2); i(3) = m_b(3)/nA(3); % Current

%endfunction