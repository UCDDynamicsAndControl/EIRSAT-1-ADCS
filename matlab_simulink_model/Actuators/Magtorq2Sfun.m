function Magtorq2Sfun(block)
%Magtorq2Sfun a block which converts a torq specified by a controller to
%one created by magnetorquer. Give a desired torque as an input. the dipole
%which creates such a torque is calculated. and used to calculate the
%output torque. the output torque is the component of the input torque in
%the plane perpendicular to B

setup(block);
  
%endfunction

function setup(block)
  % Register the number of paramenters.
  block.NumDialogPrms = 3;
  % Register the number of ports.
  block.NumInputPorts  = 4;
  block.NumOutputPorts = 4;
  
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
  
  block.InputPort(4).DatatypeID  = 0;  % double
  block.InputPort(4).Complexity  = 'Real';
  block.InputPort(4).Dimensions  = 4;
  block.InputPort(4).DirectFeedthrough = false;
  block.InputPort(4).SamplingMode='Sample';
  
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
  
  block.OutputPort(4).DatatypeID  = 0; % double
  block.OutputPort(4).Complexity  = 'Real';
  block.OutputPort(4).Dimensions  = 3;
  block.OutputPort(4).SamplingMode='Sample';
 

  block.SampleTimes = [0 0];
  
  % -----------------------------------------------------------------
  % Options
  % -----------------------------------------------------------------
  % Specify if Accelerator should use TLC or call back to the 
  % MATLAB file
  block.SetAccelRunOnTLC(false);
  

  block.SimStateCompliance = 'DefaultSimState';


  block.RegBlockMethod('Outputs', @Outputs);
  block.RegBlockMethod('InitializeConditions', @InitializeConditions);


%endfunction

% -------------------------------------------------------------------
% The local functions below are provided to illustrate how you may implement
% the various block methods listed above.
% -------------------------------------------------------------------

function InitializeConditions(block)

  block.OutputPort(1).Data = [0;0;0];%cross(m_b,B_real); % Actuator Torque
  block.OutputPort(2).Data = [0;0;0];%m_b; % Magnetic dipole
  block.OutputPort(3).Data = [0;0;0];%i;
%endfunction 

function Outputs(block)
  i = zeros(3,1);
  nAx= block.DialogPrm(1).Data; % Coils data
  nAy = block.DialogPrm(2).Data;
  nAz = block.DialogPrm(3).Data;
  T_spec=block.InputPort(1).Data;% torque specified by controller
  B_real=block.InputPort(2).Data;% actual B vector
  B_meas=block.InputPort(3).Data;% measured B vector
  if B_real==0 %this s-fun getscalled before IGRF, this block reads the value for B before it is calculated. leads to errors
      B_real=[1.0793e-5;-3.0222e-6;-2.2649e-5];
      B_meas=[1.0793e-5;-3.0222e-6;-2.2649e-5];
  end
  q=block.InputPort(4).Data;
  n=q(1);
  eta=q(2:3);
  S=SkewSym(eta);
  Rotm=transpose(eye(3)+(2*((n*S)+(S^2))));
  B_real=Rotm*B_real;
  B_meas=Rotm*B_meas;
  
  
  m_b=(cross(B_meas,T_spec))/(norm(B_meas)^2);%-pinv(SkewSym(B_meas))*T_spec;
%   if isnan(m_b)
%       m_b=[0;0;0];
%   end
  i(1) = m_b(1)/nAx; i(2) = m_b(2)/nAy; i(3) = m_b(3)/nAz;
  block.OutputPort(1).Data = cross(m_b,B_real); % Actuator Torque
  block.OutputPort(2).Data = m_b; % Magnetic dipole
  block.OutputPort(3).Data = i; % Current
  block.OutputPort(4).Data = B_meas;
  
  
%endfunction

 
 

