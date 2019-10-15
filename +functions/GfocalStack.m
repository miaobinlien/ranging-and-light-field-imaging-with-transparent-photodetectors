function A = GfocalStack(varargin)
    arg = struct('camera', [], 'g', []);
    arg = vararg_pair(arg, varargin);

    % Compute g
    arg.g = compute_g(arg);

    cam = arg.camera;
    nx = cam.arg.nx; ny = cam.arg.ny; nu = cam.arg.nu; nv = cam.arg.nv;
    nF = length( cam.arg.focalStackDis );

    [~, ~, u, v] = cam.createAxes();
    [uu, vv] = ndgrid(u, v);
    arg.apeMask = ( (uu).^2 + (vv).^2 <= (cam.arg.apeSize/2)^2 );

    imask = true(nx, ny, nu, nv);
    omask = true(nx, ny, nF);

    A = fatrix2('imask', imask, 'omask', omask,...
                'arg', arg, 'forw', @forward_project, 'back', @back_project);
end

function g = compute_g(arg)
    cam = arg.camera;
    [x, y, u, v] = cam.createAxes();
    [X, Y, U, V] = ndgrid(x, y, u, v);
    nx = cam.arg.nx; ny = cam.arg.ny; nu = cam.arg.nu; nv = cam.arg.nv;
    dx = cam.arg.dx; dy = cam.arg.dy; du = cam.arg.du; dv = cam.arg.dv;

    focalStackDis = cam.arg.focalStackDis;
    D = cam.arg.refDis;
    focalLen = cam.arg.focalLen;
    nF = length(focalStackDis);

    g = zeros(nx, ny, nu, nv, nF);

    z = 1./(1/focalLen - 1./focalStackDis);
    for iF = 1:nF
        f = 1/(1/z(iF) + 1/D);

        a = 1;
        b = D/f - D/focalLen;
        c = 0;
        d = 1;

        ab = abs(b);

        if b == 0
            f = @(x, u, dx) (min(dx/2, x+dx/2) - max(-dx/2, x-dx/2)).*(min(dx/2, x+dx/2) > max(-dx/2, x-dx/2)).*u;
        else
            f = @(x, u, dx) (dx*(u-x/b) - ab/2*sign(u-x/b).*(u-x/b).^2).*(abs(u-x/b) <= dx/ab) +...
                            (sign(u-x/b)*dx^2/2/ab).*(abs(u-x/b) > dx/ab);
        end
        st_h = f(X, U+du/2, dx) - f(X, U-du/2, dx);
        st_v = f(Y, V+dv/2, dy) - f(Y, V-dv/2, dy);

        g(:, :, :, :, iF) = st_h.*st_v;
    end
end

function focalStack = forward_project(arg, lightfield)
    import utilities.*;
    cam = arg.camera;
    nx = cam.arg.nx; ny = cam.arg.ny; nu = cam.arg.nu; nv = cam.arg.nv;
    nF = length( cam.arg.focalStackDis );

    apeMask = arg.apeMask;

    focalStack = zeros(nx, ny, nF);
    g = arg.g;

    for iF = 1:nF
        img = zeros(nx, ny);
        for iu = 1:nu
            for iv = 1:nv
                if apeMask(iu, iv)
                    img = img + conv2( lightfield(:, :, iu, iv), g(:, :, nu+1-iu, nv+1-iv, iF), 'same' );
                end
            end
        end
        focalStack(:, :, iF) = img;
    end
end

function lightfield = back_project(arg, focalStack)
    cam = arg.camera;
    nx = cam.arg.nx; ny = cam.arg.ny; nu = cam.arg.nu; nv = cam.arg.nv;
    nF = length( cam.arg.focalStackDis );

    apeMask = arg.apeMask;

    lightfield = zeros(nx, ny, nu, nv);
    g = arg.g;

    for iu = 1:nu
        for iv = 1:nv
            if apeMask(iu, iv)
                img = zeros(nx, ny);
                for iF = 1:nF
                    img = img + conv2( focalStack(:, :, iF), rot90( g(:, :, nu+1-iu, nv+1-iv, iF), 2 ), 'same' );
                end
                lightfield(:, :, iu, iv) = img;
            end
        end
    end
end