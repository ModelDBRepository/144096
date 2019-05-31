function showMultiplot( yResult, plotfun, plotfunxlim, plotfunylim, bFlipUD )

    if nargin <= 4
        bFlipUD = 0;
    end

    nRows = size( yResult, 1 );
    nCols = size( yResult, 2 );

    figure;
    for i = 1:nRows
        for j = 1:nCols
            if bFlipUD
                subplot( nRows, nCols, spos(nCols,j,nRows-(i-1),1,1) );
            else
                subplot( nRows, nCols, spos(nCols,j,i,1,1) );
            end
            plotfun( yResult{i,j} );
            set( gca, 'XLim', plotfunxlim(yResult{i,j}) );
            set( gca, 'YLim', plotfunylim(yResult{i,j}) );
            axis off;
        end
    end
