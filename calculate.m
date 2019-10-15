import classes.*
import functions.*
import utilities.*

if updateMode
    %% Setup the discrete scene (complex scene from the 4D Lightfield Benchmark)
    if complexScene
        f = 50;    
        workRange = [19.7158 25.5545]*100;
        fsDis = setFocalStackDis(workRange, nF, 'even Fourier slice');

        argCam = { 'nx', 511,  'ny', 511,  'dx', 0.04, 'dy', 0.04, ...
                   'nu', 9,    'nv', 9,   'du', 20,  'dv', 20, ...
                   'focalLen', f, 'apeSize', 160, 'focalStackDis', fsDis, 'refDis', 1/(1/f-1/2200) };
        cam = Camera( argCam{:} );

        tic;
        trueLF = importLF('4D LF Benchmark', 'sideboard', cam);
        t = toc;
        disp(['Time to import LF = ' num2str(t) ' sec']);

        sceneType = 'complex';
    else
        f = 50;
        workRange = [300 3000];
        fsDis = setFocalStackDis(workRange, nF, 'even Fourier slice');

        argCam = { 'nx', 301,  'ny', 301,  'dx', 0.01, 'dy', 0.01, ...
                   'nu', 11,   'nv', 11,   'du', 0.6,  'dv', 0.6, ...
                   'focalLen', f, 'apeSize', 6, 'focalStackDis', fsDis };
        cam = Camera( argCam{:} );

        R = 8;
        Disk = @(x, y) (1 + (cos(1*pi*sqrt(x.^2 + y.^2)) > 0).*(x > -y) + ... 
                            (cos(2/3*pi*sqrt(x.^2 + y.^2)) > 0).*(x <= -y)).*(x.^2 + y.^2 < R^2);

        argScene = { 'objects', {Disk, Disk}, 'positions', {[-4+2.5, -4+2.5, 467], [4+2.5, 4+2.5, 648.1]} };
        scene = Scene( argScene{:} );
        
        contLF = cmpContLF(cam, scene);
        trueLF = cmpDiscLF(cam, contLF);
        sceneType = 'cont';
    end
    trueLF = trueLF/max(trueLF(:));

    A = GfocalStack('camera', cam);

    tic;
    trueFS = A*trueLF;
    t = toc;
    disp(['Time to generate FS = ' num2str(t) ' sec']);
    save(['lf_' sceneType '.mat']);

elseif exist('trueLF', 'var') == 0
    load(['lf_' sceneType '.mat']);
end

if reconMode
    reconLF = reconGD(trueFS, A, trueLF);
end