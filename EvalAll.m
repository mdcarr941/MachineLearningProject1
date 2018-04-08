%%% EvalAll %%%
% Run EvalClustRGB on all the segmented images in a given directory.

ResultsDir = 'CalcdSegs';
ImgDir = 'ImsAndSegs';

fileList = dir(ResultsDir);
for i = 1:length(fileList)
    if ~fileList(i).isdir || strcmp(fileList(i).name, '.') ...
            || strcmp(fileList(i).name, '..')
        continue
    end
    
    resultsPath = fullfile(fileList(i).folder, fileList(i).name);
	matFiles = dir(fullfile(resultsPath, '*.mat'));
        
    fileNumbers = zeros(1, length(matFiles));
    OCEValues = zeros(length(matFiles), 3);
    scores = zeros(1, length(matFiles));
	
    outputFile = strcat('Eval', fileList(i).name, '.mat');
    if exist(outputFile, 'file') == 2
        load(outputFile);
    end
    
    if any(size(fileNumbers) ~= [1, length(matFiles)])
        fileNumbers = fileNumbers(:, 1)';
        while numel(fileNumbers) < length(matFiles)
            fileNumbers(end + 1) = 0;
        end
    end
    
    while size(OCEValues, 1) < length(matFiles)
        OCEValues(end + 1, :) = [0, 0, 0];
    end
    
    while numel(scores) < length(matFiles)
        scores(end + 1) = 0;
    end
    
    for j = 1:length(matFiles)
	    % Get the file number from each mat file.
        fileNumbers(j) = str2double(matFiles(j).name(1 : end - length('Seg.mat')));
		load(fullfile(resultsPath, matFiles(j).name));
		load(fullfile(ImgDir, strcat('ImsAndTruths', num2str(fileNumbers(j)), '.mat')));
        Segs = {Seg1, Seg2, Seg3};
        for k = 1:3
            if OCEValues(j, k) ~= 0
                continue
            end
            OCEValues(j, k) = EvalClustRGB(CCIm, Segs{k});
        end
        scores(j) = min(OCEValues(j, :));
    end
    
    scoresMean = mean(scores);
    scoresStdDev = std(scores);
    
    fprintf('Writing %s\n', outputFile);
    save(outputFile, 'fileNumbers', 'OCEValues', 'scores', 'scoresMean', 'scoresStdDev');
end