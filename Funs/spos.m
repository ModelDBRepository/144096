% ---------------------------------------------------------------------------
% The function 'spos' sets the position for a subplot in the style of
% a java grid bag layout.
%
% Input:
%	cols	number of columns in the subplot
%	x, y	coordinates for the subplot, starting by 1
%	w, h	width and height
%
% ---------------------------------------------------------------------------

function pos = spos( cols, x, y, w, h )
    pos = [ (y-1) * cols + x, (y+h-2) * cols + (x+w-1) ];

