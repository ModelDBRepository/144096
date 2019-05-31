% ----------------------------------------------------------------------
% This script performs simple model explorations.
%
% 31/8/2011,    Initial revision created
%               Lars Schwabe (lars.schwabe@uni-rostock.de)
% ----------------------------------------------------------------------

clear all;
close all;

path( path, fullfile('.','Funs') );
path( path, getenv('ARSENV_MATLABMISC') );

mkModelParams;

% Parameters for the simulation(s)
SimParams.T_START = 0;      % start time for integration
SimParams.T_END   = 0.750;  % end time for integration
SimParams.T_SUR   = 0.400;  % time for adding the surround

% ------------------------------------------------------------
%
% ------------------------------------------------------------

M = ModelParams;
M.sName = 'EBI Model';

%nW = 6;
%vW = linspace( 0, 10, nW );
vW = [0 1 2 4 10 20];
nW = length(vW);
yR = cell( 1, nW );

mSurResponse1 = zeros( nW, M.N );
mSurResponse2 = zeros( nW, M.N );

% Run simulations with all surround orientations
SimParams.ORICTR = 90 - 22.5;
for iW = 1:length(vW)
    W = vW(iW);
    K = 1.2;
    M.W_EE = W;
    M.W_BE = W;
    M.W_EB = -K*W;
    M.W_BB = -K*W;
    M.W_ES = -0.01;
    M.W_BS = +0.02;

    M.KAPPA_REC_BSK = 0.2;
    M.KAPPA_REC_EXC = 0.2;
    R = simulate( M, SimParams );
    iCtrE = findclosest( R.vPO, 90 );
    mSurResponse1(iW,:) = R.mRE_final(:,iCtrE)';

    M.KAPPA_REC_BSK = 2;
    M.KAPPA_REC_EXC = 2;
    R = simulate( M, SimParams );
    mSurResponse2(iW,:) = R.mRE_final(:,iCtrE)';

end

%% Save results
save( fullfile('.','Data','dataExploration.mat'), 'R', 'M', 'nW', 'mSurResponse1', 'mSurResponse2' );
