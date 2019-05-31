function vY = circgauss( vX, A, mu, sigma )

    vD = abs(vX-mu);
    vD = min( vD, 180-vD );
    vY = A * exp( -vD.^2 ./ (2*sigma*sigma) );
