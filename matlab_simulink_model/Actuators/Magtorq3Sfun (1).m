function Magtorq3Sfun(block)
%MSFUNTMPL A Template for a MATLAB S-Function

setup(block);
  
%endfunction

function setup(block)
  
  % Register the number of parameters
  block.NumDialogPrms = 4;
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
  nAx = block.DialogPrm(2).Data; % Coils data
  nAy = block.DialogPrm(3).Data;
  nAz = block.DialogPrm(4).Data;
  tolerance=block.DialogPrm(1).Data; % Control tolerance, from parameters
  T_spec=block.InputPort(1).Data;% Torque specified by controller
  B_real=block.InputPort(2).Data;% Actual B vector
  B_meas=block.InputPort(3).Data;% Measured B vector
  nA = [nAx,nAy,nAz];
  [m_b,T_act,i] = Magtorq3(B_meas,B_real,T_spec,tolerance,nA); %Calculate magnetic dipole and generate torque, according to the control law
  block.OutputPort(1).Data = T_act; % Actuator torque
  block.OutputPort(2).Data = m_b; % Magnetic dipole
  block.OutputPort(3).Data = i; % Current
%endfunction

function [m_b,T_act,i] = Magtorq3(B_meas,B_real,T_spec,tolerance,nA)
i = zeros(3,1);
m_test = (1/(norm(B_meas)^2))*(cross(B_meas,T_spec));
T_test = cross(m_test,B_meas);
cosTol = cos(tolerance);
cosErr = dot(T_spec,T_test)/(norm(T_spec)*norm(T_test));
if cosErr > cosTol
    m_b = m_test;
    T_act = cross(m_test,B_real); % Recall that the actual torque is given by the real magnetic field. 
else
    m_b = [0;0;0]
    T_act = [0;0;0];
end
i(1) = m_b(1)/nA(1); i(2) = m_b(2)/nA(2); i(3) = m_b(3)/nA(3); % Current
%endfunction
    


