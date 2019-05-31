clear all;
close all;

path( path, fullfile('.','Funs') );

% Generate Matlab workspaces in the 'Data' subfolder.
disp('Running simulations (for 3 models)...'); mkData3Models; disp('Done.');

% Generate figures.
disp('Generating figures (for 3 models)...'); mkFigs3Models; disp('Done.');
