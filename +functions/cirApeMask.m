function apeMask = cirApeMask(x, y, d)
    [X, Y] = ndgrid(x, y);
    apeMask = ( X.^2 + Y.^2 <= (d/2)^2 );
end