function saveFig(figs, names, dirName)
    import utilities.genFile;

    if  numel(figs) ~= numel(names)
        disp(['Number of figures: ' int2str(numel(figs)) ', number of names: ' int2str(numel(names))]);
        error('Number of figures and names do not match');
    end

    for i = 1:numel(figs)
        file = genFile( [dirName names{i} '.jpg'] );
        saveas(figs(i), file, 'jpeg');
    end
end