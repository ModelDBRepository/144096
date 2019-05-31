ModelParams.N = 32;

ModelParams.TAU_E = 0.010;
ModelParams.TAU_B = 0.006;

ModelParams.KAPPA_REC_BSK = 0.2;
ModelParams.KAPPA_REC_EXC = 0.2;
ModelParams.KAPPA_FF  = 0.5;
ModelParams.KAPPA_MOD = 0.5;

W = 20;
K = 1.2;
ModelParams.W_EE = W;
ModelParams.W_BE = W;
ModelParams.W_EB = -K*W;
ModelParams.W_BB = -K*W;
ModelParams.W_ES = 0;
ModelParams.W_BS = 0.03;

% Parameters for the neuronal populations
ModelParams.GE = 1;         % gain of exc neurons
ModelParams.GB = 1;         % gain of bsk neurons

ModelParams.TH_E = 0.5;     % threshold of exc neurons
ModelParams.TH_B = 0.5;     % threshold of bsk neurons
