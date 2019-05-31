% ----------------------------------------------------------------------
% The function
%
%   vD = oridiff( PHI, vPHI )
%
% computes the orientation difference vD = vPHI - PHI in degree.
% ----------------------------------------------------------------------
function vD = oridiff( PHI, vPHI )

    vD = vPHI - PHI;

    idx1 = find( vD < -90 );
    vD(idx1) = vD(idx1) + 180;
    
    idx2 = find( vD > 90 );
    vD(idx2) = vD(idx2) - 180;
