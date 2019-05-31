% ----------------------------------------------------------------------
% This script generates the population responses and the response vs.
% surround orientation plots.
%
% 23/7/2011,    Explicit simulations with different ctr stimuli
%               Lars Schwabe (lars.schwabe@uni-rostock.de)
% 8/7/2011,     Initial revision created
%               Lars Schwabe (lars.schwabe@uni-rostock.de)
% ----------------------------------------------------------------------

%% Load the data.
clear all;
close all;

path( path, fullfile('.','Funs') );

load( fullfile('Data','data3Models.mat') );


%% Generate the figures.

% ----------------------------------------------------------------------
% Figure 1
% ----------------------------------------------------------------------
figure(1);

ROWS = 3;
COLS = 3;

iCtrE   = R1Opt.iCtrE;
iIso    = R1Opt.iIso;
iOffSur = -4;

for i = 1:3

    if i==1 M=M1; ROpt=R1Opt; RSub=R1Sub; end;
    if i==2 M=M2; ROpt=R2Opt; RSub=R2Sub; end;
    if i==3 M=M3; ROpt=R3Opt; RSub=R3Sub; end;

	% Population response (1st row).
    subplot( ROWS, COLS, spos(COLS,i,1,1,1) );
    base  = max( ROpt.mRE_ctrl(iIso,:) );
    vCtrl = 100 * ROpt.mRE_ctrl(iIso,:) ./ base;
    vIso  = 100 * ROpt.mRE_final(iIso,:) ./ base;
    vOff  = 100 * ROpt.mRE_final(iIso+iOffSur,:) ./ base;
    plot( ...
        ROpt.vPO, vCtrl, 'k-', ...
        ROpt.vPO, vOff, 'k:', ...
        ROpt.vPO, vIso, 'k--' );
    xlabel( 'PO [deg]' );
	if i==1 ylabel('Response [%]'); end;
    set( gca, 'YLim', [0 110] );
    set( gca, 'XLim', [ROpt.vPO(1) ROpt.vPO(end)] );
    set( gca, 'XTick', [ROpt.vPO(1) : 30 : ROpt.vPO(end)] );
    title( M.sName );

    % Response of ctr neuron to changing surround ori (2nd row).
    subplot( ROWS, COLS, spos(COLS,i,2,1,1) );
    base  = max( ROpt.mRE_ctrl(:,iCtrE) );
    vCtrl = 100 * ROpt.mRE_ctrl(:,iCtrE) ./ base;
    vIso  = 100 * ROpt.mRE_final(:,iCtrE) ./ base;
    vOff  = 100 * RSub.mRE_final(:,iCtrE) ./ base;   
    plot( ...
        ROpt.vSur, vCtrl, 'k-', ...
        ROpt.vSur, vIso, 'k--', ...
        ROpt.vSur, vOff, 'k:' );
    xlabel( 'Sur [deg]' );
	if i==1 ylabel('Response [%]'); end;
    set( gca, 'YLim', [0 110 ], 'XLim', [ROpt.vSur(1) ROpt.vSur(end)] );
    set( gca, 'XTick', [ROpt.vSur(1) : 30 : ROpt.vSur(end)] );

end


%% Print the figures into a file.
print( '-depsc2', fullfile('Figs','fig3Models.eps'), '-f1' );
