function MagtorqSfun(block)
%MSFUNTMPL A Template for a MATLAB S-Function

setup(block);
  
%endfunction

function setup(block)

  block.NumDialogPrms = 0;
  % Register the number of ports.
  block.NumInputPorts  = 3;
  block.NumOutputPorts = 2;
  
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
  T_spec=block.InputPort(1).Data;%torque specified by controller
  B_real=block.InputPort(2).Data;%actual B vector
  B_meas=block.InputPort(3).Data;%measured B vector
  m_b=-pinv(SkewSym(B_meas))*T_spec;%magtorq dipole which will create the required torque
  block.OutputPort(1).Data = cross(m_b,B_real);
  block.OutputPort(2).Data = m_b;
  
%endfunction

    
 

