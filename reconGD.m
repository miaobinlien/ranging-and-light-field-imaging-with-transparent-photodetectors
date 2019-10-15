function reconLF = reconGD(trueFS, A, trueLF)
    import utilities.*;
    import functions.*;

    disp('Recon using GD...');

    nIter = 25;

    reconLF = A'*trueFS;
    reconLF = reconLF/max(reconLF(:));

    alpha = 1.5e-2/size(trueFS, 3);

    condition = true;
    iter = 0;
    while condition
        df = 2*A'*(A*reconLF - trueFS);
        reconLF = reconLF - alpha*df;
        condition = (iter < nIter);
        iter = iter + 1;
    end
    reconLF = max(reconLF, 0);
end