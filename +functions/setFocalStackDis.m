function fsDis = setFocalStackDis(workRange, nF, option, varargin)
    switch option
        case 'linear'
            f = 50;
            W12 = [max(workRange) min(workRange)];
            B12 = 1./(1/f - 1./W12);
            fsDis = linspace(B12(1), B12(2), nF);
        case 'even Fourier slice'
            f = 50;
            N = nF;

            W12 = [max(workRange) min(workRange)];
            B12 = 1./(1/f - 1./W12);

            W1 = W12(1);
            W2 = W12(2);

            syms b
            eqn = ( pi + atan(1/(b/f-b/W2-1)) - atan(1/(b/f-b/W1-1)) )/(2*N) == pi/2 + atan(1/(b/f-b/W2-1));

            beta = double( vpasolve(eqn, b, B12) );
            thetaW1 = atan(1/(beta/f-beta/W1-1));
            thetaW2 = pi + atan(1/(beta/f-beta/W2-1));
            dtheta = (thetaW2-thetaW1)/N;

            d = 1:N;
            thetad = thetaW1+dtheta/2 + (d-1)*dtheta;
            fsDis = beta*tan(thetad)./(1 + tan(thetad));
        otherwise
            error('Invalid/Null option name.');
    end
end