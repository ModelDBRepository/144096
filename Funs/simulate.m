% ----------------------------------------------------------------------
% This function simulates a network with the model parameters given
% in 'ModelParams' and simulation parameters given in 'SimParams'.
% ----------------------------------------------------------------------

function Result = simulate( ModelParams, SimParams )

    % ----------------------------------------
    % Set up the model
    % ----------------------------------------

    % Label neurons by their preferred orientation
	Result.vPO   = [ 0 : 180/ModelParams.N : 180 - 180/ModelParams.N ];
    Result.iCtrE = findclosest( Result.vPO, SimParams.ORICTR );

	% Set up recurrent weights
	mW_EXC = zeros( ModelParams.N );
	mW_BSK = zeros( ModelParams.N );
    if isfield(ModelParams,'bDiag')
        mW_EXC = eye( ModelParams.N );
        mW_BSK = eye( ModelParams.N );
    else
        for i = 1:ModelParams.N
            vD = pi / (2*90) * oridiff(Result.vPO(i),Result.vPO);

            % Recurrent exc projections
            mW_EXC(i,:) = exp( ModelParams.KAPPA_REC_EXC*cos(2*vD) );
            mW_EXC(i,:) = mW_EXC(i,:) / sum(mW_EXC(i,:));

            % Recurrent bsk projections
            mW_BSK(i,:) = exp( ModelParams.KAPPA_REC_BSK*cos(2*vD) );
            mW_BSK(i,:) = mW_BSK(i,:) / sum(mW_BSK(i,:));   
        end
    end
	mWEE = ModelParams.W_EE * mW_EXC;
	mWBE = ModelParams.W_BE * mW_EXC;
	mWEB = ModelParams.W_EB * mW_BSK;
	mWBB = ModelParams.W_BB * mW_BSK;
	mW = [ mWEE mWEB; mWBE mWBB ];

    % ----------------------------------------
    % Configure the simulation(s)
    % ----------------------------------------

    % Surround orientations
    if isfield(SimParams,'vSur')
        Result.vSur = SimParams.vSur;
    else
        Result.vSur = [ 0 : 180/ModelParams.N : 180 - 180/ModelParams.N ];
    end
    nSur = length(Result.vSur);
    Result.iIso = findclosest( Result.vSur, SimParams.ORICTR );

	% Compute feedforward inputs 'iexte' and 'iextb'
    if isfield(SimParams,'vIExt')
        iext = SimParams.vIExt / max(SimParams.vIExt);
    else
        vD = pi / (2*90) * oridiff(SimParams.ORICTR,Result.vPO);
        iext = exp( ModelParams.KAPPA_FF*cos(2*vD) )';
    end
    iext = iext / max(iext);
    iexte = 1*iext;
    iextb = 1*iext;

    % Initialize variables to be observed
	Result.mRE_ctrl   = zeros(nSur,ModelParams.N);
	Result.mRB_ctrl   = zeros(nSur,ModelParams.N);
	Result.mRE_final  = zeros(nSur,ModelParams.N);
	Result.mRB_final  = zeros(nSur,ModelParams.N);

	Result.mIE_LOC_EE = zeros(nSur,ModelParams.N);
	Result.mIE_LOC_EB = zeros(nSur,ModelParams.N);
	Result.mIE_FF     = zeros(nSur,ModelParams.N);
	Result.mIE_SUR    = zeros(nSur,ModelParams.N);

	Result.mIB_LOC_BE = zeros(nSur,ModelParams.N);
	Result.mIB_LOC_BB = zeros(nSur,ModelParams.N);
	Result.mIB_FF     = zeros(nSur,ModelParams.N);
	Result.mIB_SUR    = zeros(nSur,ModelParams.N);

    Result.yT  = cell( 1, nSur );
    Result.yRE = cell( 1, nSur );
    Result.yRB = cell( 1, nSur );

    % ----------------------------------------
    % Run the simulation(s)
    % ----------------------------------------

    % For each surround orientation 'iSur'
	for iSur = 1:nSur

		% Pre-compute modulatory inputs 'imode' and 'imodb'
		vD = pi / (2*90) * oridiff( Result.vSur(iSur), Result.vPO );
		imod = exp( ModelParams.KAPPA_MOD*cos(2*vD) )';
		imod = imod / max(imod);

		imode = ModelParams.W_ES*imod;
		imodb = ModelParams.W_BS*imod;
	
		vRE = zeros( ModelParams.N, 1 );
		vRB = zeros( ModelParams.N, 1 );

		vX0 = zeros( 2*ModelParams.N, 1 );
        [vT,mX] = ode45( @myrhs, [SimParams.T_START SimParams.T_END], vX0 );

        % Determine stability by inspecting time course largest entry
        [val,idx] = max( abs(mX(end,:)) );
        vDX = mX( 2:end,idx(1) ) - mX( 1:end-1,idx(1) );
        vDX = vDX ./ mX( 1:end-1,idx(1) );
        Result.bIsStable = mean( vDX(end-10:end) ) < 0.005;

        % Find time index 10ms before the surround is added (as ctrl)
        iT = findclosest( vT, SimParams.T_SUR-0.010 );

        % Record population activity for "ctr only", and "ctr+sur"
		Result.mRE_ctrl(iSur,:)  = mX(iT,1:ModelParams.N);
		Result.mRB_ctrl(iSur,:)  = mX(iT,ModelParams.N+1:end);
		Result.mRE_final(iSur,:) = mX(end,1:ModelParams.N);
		Result.mRB_final(iSur,:) = mX(end,ModelParams.N+1:end);

        % Record inputs
		Result.mIE_LOC_EE(iSur,:) = mWEE*Result.mRE_final(iSur,:)';
		Result.mIE_LOC_EB(iSur,:) = mWEB*Result.mRB_final(iSur,:)'; 
		Result.mIE_FF(iSur,:)     = iexte;
		Result.mIE_SUR(iSur,:)    = imode;

		Result.mIB_LOC_BE(iSur,:) = mWBE*Result.mRE_final(iSur,:)';
		Result.mIB_LOC_BB(iSur,:) = mWBB*Result.mRB_final(iSur,:)'; 
		Result.mIB_FF(iSur,:)     = iextb;
		Result.mIB_SUR(iSur,:)    = imodb;

        % ----------------------------------------
        % Bookeep simulation results
        % ----------------------------------------

        Result.yT{iSur} = vT;
        Result.yRE{iSur} = mX(:,1:ModelParams.N);
        Result.yRB{iSur} = mX(:,ModelParams.N+1:end);

        % Return final weight matrix as all
        Result.mW = mW;

	end

    % ----------------------------------------
    % Definition of the rhs of the ODE
    % ----------------------------------------
    function xdot = myrhs( t, vX )
        re = vX(1:ModelParams.N);
        rb = vX(ModelParams.N+1:end);
        if t>SimParams.T_SUR
            ie = mWEE*re + mWEB*rb + iexte + imode;
            ib = mWBE*re + mWBB*rb + iextb + imodb;
        else
            ie = mWEE*re + mWEB*rb + iexte;
            ib = mWBE*re + mWBB*rb + iextb;
        end
        redot = ( -re + ModelParams.GE*max(ie-ModelParams.TH_E,0) ) / ModelParams.TAU_E;
        rbdot = ( -rb + ModelParams.GB*max(ib-ModelParams.TH_B,0) ) / ModelParams.TAU_B;
        xdot = [ redot; rbdot ];
    end

end
