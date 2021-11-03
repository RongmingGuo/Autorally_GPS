function [Data] = dataExtract(fileName)

    fN = fileName + 'txt';
    fid = fopen(fN);
    
    Data = [];
    
    while (isempty(fgetl(fid)) == 0)
        rowData = [];
        theLine = fgetl(fid);
        ColData = split(theLine, ',');
        ColData = ColData((7 : (end - 1)), :); % Extracting Only LLA and Covariance Data
    
        for i = 1 : length(ColData)
            rowData = [rowData, str2num(ColData{i})];
        end
    
        Data = [Data; rowData];
    end
    
    fclose(fid);
end
