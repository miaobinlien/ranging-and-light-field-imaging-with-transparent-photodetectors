cwd = pwd;
run([cwd '\irt\setup.m']);
run([cwd '\alg\setup.m']);

import classes.*
import functions.*
import utilities.*

%% Generate figures on NPHOT: Ranging and Light Field Imaging with Transparent Photodetectors
Fig4a = false;
Fig4b_e = false;
Fig3Sb = true;

if Fig4a
    updateMode = true;
    complexScene = false;
    reconMode = false;

    nF = 5;
    calculate;

    dirName = 'fig/';
    objTrueFS = FocalStack('camera', cam, 'focalStack', trueFS, 'focalStackDis', fsDis, 'name', 'True Focal Stack');
    fsFigs = objTrueFS.plotFS();   
    saveFig(fsFigs, string(fsDis), dirName);
    for fsFig = fsFigs
        set(fsFig, 'Visible', 'off');
    end
end
if Fig4b_e
    updateMode = true;
    complexScene = true;
    reconMode = true;

    nF = 5;
    calculate;

    dirName = 'fig/';
    objTrueFS = FocalStack('camera', cam, 'focalStack', trueFS, 'focalStackDis', fsDis, 'name', 'True Focal Stack');
    fsFigs = objTrueFS.plotFS();   
    saveFig(fsFigs, string(fsDis), dirName);
    for fsFig = fsFigs
        set(fsFig, 'Visible', 'off');
    end

    viewFigs = gobjects(1, 4);
    cv = cenView(trueLF);
    cv = cv/max(cv(:));
    viewFigs(1) = figure; imgDisplay(cv);
    cv = cenView(reconLF);
    cv = cv/max(cv(:));
    viewFigs(2) = figure; imgDisplay(cv);
    i1 = sub2ind([9 9], 2, 5);
    I1 = reconLF(:, :, i1);
    viewFigs(3) = figure; imgDisplay(I1);
    i2 = sub2ind([9 9], 8, 5);
    I2 = reconLF(:, :, i2);
    viewFigs(4) = figure; imgDisplay(I2);
    saveFig(viewFigs, ["cv_trueLF", "cv_reconLF", "I1_reconLF", "I2_reconLF"], dirName);
    for viewFig = viewFigs
        set(viewFig, 'Visible', 'off');
    end
end
if Fig3Sb
    updateMode = true;
    complexScene = true;
    reconMode = true;

    f = 50;
    depth = linspace(1.97, 2.56, 25)*1000;
    fsDis = 1./(1/f-1./depth);
    argCam = { 'nx', 511,  'ny', 511,  'dx', 0.04, 'dy', 0.04, ...
               'nu', 9,   'nv', 9,   'du', 20,  'dv', 20, ...
               'focalLen', f, 'apeSize', 160, 'focalStackDis', fsDis, 'refDis', 1/(1/f-1/2200) };
    cam = Camera( argCam{:} );
    Arefocus = GfocalStack('camera', cam);

    nFilms = [2 3 4 5 10 20];
    errors = zeros(length(nFilms), length(depth));

    figure;
    for i = nFilms
        nF = i;
        calculate;

        trueFS = Arefocus*trueLF;
        reconFS = Arefocus*reconLF;
        for j = 1:length(depth)
            error = trueFS(:, :, j) - reconFS(:, :, j);
            trueFSj = trueFS(:, :, j);
            errors(i, j) = norm(error(:))/norm(trueFSj(:));
        end

        h = plot(depth/1000, errors(i, :),... 
                 '-o',...
                 'LineWidth', 2,...
                 'MarkerSize', 5, ...
                 'DisplayName', ['N = ' num2str(i)]);
        set(h, 'MarkerFaceColor', get(h, 'Color'));
        hold on;
    end
    legend('show', 'Location', 'northwest');
    title('\textbf{Refocusing Error}', 'FontSize', 16, 'interpreter', 'latex')
    xlabel('\textbf{Position of focus (m)}', 'FontSize', 12, 'interpreter', 'latex');
    ylabel('\textbf{MSE}', 'FontSize', 12, 'interpreter', 'latex');
    set(gca,'GridLineStyle', ':', 'FontWeight', 'bold', 'Fontsize', 14, 'linewidth', 2.4);
    axis([1.9 2.6 0 0.08]);
end