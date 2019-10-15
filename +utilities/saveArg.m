function saveArg(args, names, fileName)
    import utilities.genFile;

    if  numel(args) ~= numel(names)
        error('Number of args and names do not match');
    end

    file = genFile(fileName);

    precision = 5;
    limit = 20;

    fileID = fopen(file, 'w');
    for i = 1:numel(args)
        arg = args{i};
        name = names{i};
        fprintf(fileID, 'Arguments of %s:\r\n', name);

        fNames = fieldnames(arg);
        for j = 1:length(fNames)
            fName = fNames{j};
            fVal = arg.(fNames{j});

            if iscell(fVal)
                if all( cellfun(@(x) isnumeric(x), fVal) )
                    if sum( cellfun(@(x) numel(x), fVal) ) <= limit
                        fVal = ['{' strjoin( cellfun(@(x) mat2str(x), fVal, 'UniformOutput', false), ',' ) '}'];
                    else
                        fVal = ['numeric cell array (numel > ' num2str(limit) ')'];
                    end
                    fprintf(fileID, ' - %s = %s\r\n', fName, fVal);
                elseif iscellstr(fVal)
                    if numel(fVal) <= limit
                        fVal = ['{' strjoin(fVal, ',') '}'];
                    else
                        fVal = ['string cell array (numel > ' num2str(limit) ')'];
                    end
                    fprintf(fileID, ' - %s = %s\r\n', fName, fVal);
                elseif all( cellfun(@(x) isstruct(x), fVal) )
                    fprintf(fileID, ' - %s = cell array of struct\r\n', fName);
                else
                    fprintf(fileID, ' - %s = cell array of other obj\r\n', fName);
                end
            elseif ~isnumeric(fVal)
                if ischar(fVal)
                    fprintf(fileID, ' - %s = %s\r\n', fName, fVal);
                elseif isstruct(fVal)
                    fprintf(fileID, ' - %s = struct\r\n', fName);
                else
                    fprintf(fileID, ' - %s = other obj\r\n', fName);
                end
            elseif isvector(fVal)
                if numel(fVal) <= limit
                    fprintf(fileID, [' - %s = ' mat2str(fVal, precision) '\r\n'], fName);
                else
                    fprintf(fileID, ' - %s = %s\r\n', fName, ['vector (numel > ' num2str(limit) ')']);
                end
            elseif ismatrix(fVal) && numel(fVal) > 0
                if numel(fVal) <= limit
                    fprintf(fileID, [' - %s = ' mat2str(fVal, precision) '\r\n'], fName);
                else
                    fprintf(fileID, ' - %s = %s\r\n', fName, ['matrix (numel > ' num2str(limit) ')']);
                end
            end
        end
        fprintf(fileID, '\r\n');
    end
    fclose(fileID);
end