function i = findclosest( v, val )

    [val,idx] = min( abs(v-val) );
    i = idx(1);
