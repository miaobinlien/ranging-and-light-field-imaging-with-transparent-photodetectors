function contLF = cmpContLF(cam, scene)
    printf('Generating contLF from scene...');

    % Reorder Objects according to the Depths
    n = length(scene.arg.positions);

    objects = scene.arg.objects;
    depths = zeros(n, 1);
    xyOffsets = zeros(n, 2);

    for i = 1:n
        position = cell2mat(scene.arg.positions(i));
        depths(i, 1) = position(1, 3);
        xyOffsets(i, :) = position(1:2);
    end

    [~, order] = sort(depths);
    objects = objects(order);
    depths = depths(order);
    xyOffsets = xyOffsets(order, :);

    contLF = @(x, y, u, v) 0;
    window = @(x, y, u, v) 1;

    D = cam.arg.refDis;
    f = cam.arg.focalLen;
    for i = 1:n
        d = depths(i);
        object = objects{i};
        xyOffset = xyOffsets(i, :);

        T = [ -d/D, (1 - d/f + d/D) ];

        objLF = @(x, y, u, v) object(T(1)*x+T(2)*u-xyOffset(1), T(1)*y+T(2)*v-xyOffset(2));
        occludedObjLF = @(x, y, u, v) objLF(x, y, u, v) .* window(x, y, u, v);
        window = @(x, y, u, v) window(x, y, u, v) .* (occludedObjLF(x, y, u, v) == 0);
        contLF = @(x, y, u, v) contLF(x, y, u, v) + occludedObjLF(x, y, u, v);
    end
end
