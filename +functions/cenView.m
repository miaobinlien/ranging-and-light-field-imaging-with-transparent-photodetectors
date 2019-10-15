function cv = cenView(lf)
    icuv = (1 + size(lf, 3)*size(lf, 4))/2;
    cv = lf(:, :, icuv);
end