function file = genFile(fileName)
    [dir, name, ext] = fileparts(fileName);

    if ~isempty(dir) && exist(dir, 'dir') == 0
        mkdir(dir);
    end
    file = [dir '/' name ext];
    i = 1;
    while exist(file, 'file') == 2
        file = [dir '/' name ' - Copy(' num2str(i) ')' ext];
        i = i+1;
    end
end