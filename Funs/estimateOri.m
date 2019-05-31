%
% Estimate the presented orientation based
% on the activies in 'vAct' with corresponding
% orientation preferences 'vPO'.
%
function vOri = estimateOri( vPO, vAct )

    vOri = [];

    [val,idx] = max( vAct );
    vOri = [ vOri vPO(idx(1)) ];

end
