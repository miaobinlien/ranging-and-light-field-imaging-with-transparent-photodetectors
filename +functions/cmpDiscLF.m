function discLF = cmpDiscLF(cam, contLF)
    printf('Generating discLF from contLF...');

    [x, y, u, v] = cam.createAxes();
    [X, Y, U, V] = ndgrid(x, y, u, v);
    discLF = contLF(X, Y, U, V);
end