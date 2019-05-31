% ----------------------------------------------------------------------
% This script generates a figure for the model exploration.
%
% 31/8/2011,    Initial revision created
%               Lars Schwabe (lars.schwabe@uni-rostock.de)
% ----------------------------------------------------------------------

%% Load the data.
clear all;
close all;

path( path, fullfile('.','Funs') );

load( fullfile('Data','dataExploration.mat') );


%% Generate the figures.

% ----------------------------------------------------------------------
% Figure 1
% ----------------------------------------------------------------------
figure(1);

ROWS = 2;
COLS = 2;

subplot( ROWS, COLS, spos(COLS,1,1,1,1) );
hold on;
for iW = 1:nW
    MAX = max( mSurResponse1(iW,:) );
    plot( R.vSur, mSurResponse1(iW,:) ./ MAX, 'k-' );
end
set( gca, 'YLim', [0 1], 'XLim', [0 R.vSur(end)] );
set( gca, 'XTick', [0:30:180] );
line( [90 90], [0 1], 'Color', 'k' );
annotation( 'arrow', [0.27 0.20], [0.85 0.65] );
hold off;
title( 'Weakly tuned LCs (kappa=0.2)' );
xlabel( 'Surround Ori [deg]' );
ylabel( 'Ctr response, PO=90 deg [norm.]' );

subplot( ROWS, COLS, spos(COLS,2,1,1,1) );
hold on;
for iW = 1:nW
    MAX = max( mSurResponse1(iW,:) );
    plot( R.vSur, mSurResponse2(iW,:) ./ MAX, 'k-' );
end
set( gca, 'YLim', [0 1], 'XLim', [0 R.vSur(end)] );
set( gca, 'XTick', [0:30:180] );
line( [90 90], [0 1], 'Color', 'k' );
annotation( 'arrow', [0.80 0.80], [0.85 0.65] );
hold off;
title( 'Tuned LCs (kappa=2)' );
xlabel( 'Surround Ori [deg]' );
ylabel( 'Ctr response, PO=90 deg [norm.]' );

%% Print the figures into a file.
print( '-depsc2', fullfile('Figs','figExploration.eps'), '-f1' );
print( '-dpng', fullfile('Figs','figExploration.png'), '-f1' );
