% ----------------------------------------------------------------------
% This script simulates the model with 3 parameter settings:
%   1) Only E neurons and suppression via I neurons
%   2) E and B neurons with suppression via B neurons
%   3) E and B neurons with suppression via B & I neurons
%
% 31/8/2011,    Put standard model parameterization into 'mkModelParams'.
%               Lars Schwabe (lars.schwabe@uni-rostock.de)
% 23/7/2011,    Explicit simulations with different ctr stimuli
%               Lars Schwabe (lars.schwabe@uni-rostock.de)
% 7/8/2011,     Initial revision created
%               Lars Schwabe (lars.schwabe@uni-rostock.de)
% ----------------------------------------------------------------------

clear all;
close all;

path( path, fullfile('.','Funs') );

mkModelParams;

% Parameters for the simulation(s)
SimParams.T_START = 0;      % start time for integration
SimParams.T_END   = 0.750;  % end time for integration
SimParams.T_SUR   = 0.400;  % time for adding the surround

% ------------------------------------------------------------
% Model 3: E and B neurons with suppression via B & I neurons
% ------------------------------------------------------------

M3 = ModelParams;

W = 20;
K = 1.2;
M3.W_EE = W;
M3.W_BE = W;
M3.W_EB = -K*W;
M3.W_BB = -K*W;
M3.W_ES = -0.01;
M3.W_BS = +0.02;
M3.sName = 'EBI Model';

% Run simulations with all surround orientations
SimParams.ORICTR = 90;
R3Opt = simulate( M3, SimParams );

SimParams.ORICTR = 90 - 22.5;
R3Sub = simulate( M3, SimParams );

% ------------------------------------------------------------
% Model 1: Only E neurons and suppression via I neurons
% ------------------------------------------------------------

M1 = ModelParams;

M1.W_EE  = 0;
M1.W_BE  = 0;
M1.W_EB  = 0;
M1.W_BB  = 0;
M1.W_ES  = -0.2;
M1.W_BS  = 0;
M1.sName = 'FF Model';

% Run simulations with all surround orientations. Set FF based on the
% final activity from R3 for the sake of comparison.
S = SimParams;
M1.TH_E = 0;
M1.TH_B = 0;

S.ORICTR = 90;
S.vIExt = R3Opt.mRE_ctrl(R3Opt.iIso,:)';
R1Opt = simulate( M1, S );

S.ORICTR = 90 - 22.5;
S.vIExt = R3Sub.mRE_ctrl(R3Sub.iIso,:)';
R1Sub = simulate( M1, S );

% ------------------------------------------------------------
% Model 2: E and B neurons with suppression via B neurons
% ------------------------------------------------------------

M2 = ModelParams;

W = 2;
K = 1.2;
M2.W_EE  = W;
M2.W_BE  = W;
M2.W_EB  = -K*W;
M2.W_BB  = -K*W;
M2.W_ES  = 0;
M2.W_BS  = 0.10;
M2.bDiag = 1;
M2.sName = 'EB Model';

% Run simulations with all surround orientations
SimParams.ORICTR = 90;
R2Opt = simulate( M2, SimParams );

SimParams.ORICTR = 90 - 22.5;
R2Sub = simulate( M2, SimParams );

%% Save results
save( fullfile('.','Data','data3Models.mat'), 'R1Opt', 'R1Sub', 'R2Opt', 'R2Sub', 'R3Opt', 'R3Sub', 'M1', 'M2', 'M3' );
