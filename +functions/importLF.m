function camLF = importLF(dataset, scene, cam)
    import functions.*;
    import utilities.*;
    printf('Import LF from dataset...');

    libFolder = 'LF Dataset';
    switch dataset
        case '4D LF Benchmark'
            load(fullfile(libFolder, dataset, [scene '.mat']));
            sceneLF = LF.LF;
            nx = cam.arg.nx; ny = cam.arg.ny; nu = cam.arg.nu; nv = cam.arg.nv;
            camLF = zeros(nx, ny, nu, nv);
            apeMask = cam.arg.apeMask;

            for iu = 1:nu
                for iv = 1:nv
                    if apeMask(iu, iv)
                        img = rgb2gray(squeeze(sceneLF(iu, iv, :, :, :)));
                        camLF(:, :, iv, iu) = rot90(img(1:end-1, 1:end-1), 2).';
                    end
                end
            end
        case 'The New Stanford Lightfield'

        otherwise
            error('Incorrect dataset name or scene name.');
    end
end