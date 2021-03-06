%% Generate 6 seconds worth of time series for the RM_AC matrix at 10^6Hz. 
%
% NOTE: This is a batch script example and so there is an exit at the end.
%
% TODO: Make use of the d parameter and get rid of this stupidity:
% Default FHN paramters produce oscilators at ~140Hz. By setting Speed to
% 70 and reinterpreting the oscilations as ~14Hz and Speed as 7 we
% effectively have 60 seconds of data. The factor of 10 in this 
% reinterpretation plus downsampling by 100 leaves us with 1 minute worth
% of 1000Hz data, which we then save. 
%
% Approximate runtime: 30 minutes, Octave, Workstation circa 2012
% Approximate memory: 4GB
% Approximate storage: 85MB 
%
% Run without GUI: 
% batch -f ./run_Generate1minScript_RM_AC &
%
%


%% Some details of our environment...
  %Where is the code
  CodeDir = '..';        %can be full or relative directory path
  ScriptDir = pwd;       %get full path to this script
  cd(CodeDir)            %Change to code directory
  FullPathCodeDir = pwd; %get full path of CodeDir
  ThisScript = mfilename; %which script is being run
  
  %When and Where did we start:
  disp(['Script started: ' when()]) 
  if strcmp(filesep,'/'), %on a *nix machine, then write machine details to our log...
    system('uname -a')
  end
  disp(['Running: ' ThisScript])
  disp(['Script directory: ' ScriptDir])
  disp(['Code directory: ' FullPathCodeDir])
 
%% Do the stuff... 
  %Set options 
  options.Connectivity.WhichMatrix = 'RM_AC';
  %Defaults produce ~140Hz FHN oscillators, a reinterpretation of 
  %Speed = 70 as Speed = 7 coresponds to ~14Hz FHN oscillators.
  Speed = 70.0;  
  options.Connectivity.invel = 1/Speed;
  
  %Load a connection matrix
  options.Connectivity = GetConnectivity(options.Connectivity);
  
  %Initialise defaults, overiding noise and integration steps
  options.Dynamics.WhichModel = 'FHN';
  options.Dynamics = SetDynamicParameters(options.Dynamics);
  options.Dynamics.Qf = 0.001;
  options.Dynamics.Qs = 0.001;
  options = SetIntegrationParameters(options);
  options.Integration.dt = 0.001;
  %With dt=0.001 and reinterp intrinsic oscillations as ~10Hz we get 1 minute
  options.Integration.iters = 6000000; 
  options = SetDerivedParameters(options);
  options = SetInitialConditions(options);

  %Integrate the network 
  [V W t] = FHN_heun(options);

  %Crude downsample
  N = size(V, 2); %Number of nodes
  DSF_t = 100;    %Down sample factor
  V = squeeze(mean(reshape(V, [DSF_t (options.Integration.iters/DSF_t) N])));
  W = squeeze(mean(reshape(W, [DSF_t (options.Integration.iters/DSF_t) N])));
  t = 10*t(((DSF_t/2)+1):DSF_t:end); %Factor of 10 is 

%% Save results to the directory of the invoking script
  save([ScriptDir filesep mfilename '.mat'])

%% When did we finish:
 disp(['Script ended: ' when()])

%% Always exit at the end when batching... 
  exit
 
%%%EoF%%%
