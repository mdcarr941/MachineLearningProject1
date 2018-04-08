OutputDir = 'CalcdSegs';
InputDir = 'ImsAndSegs';

if exist(OutputDir, 'dir') ~= 7
    mkdir(OutputDir);
end

%algorithms = {'Kmeans', 'SOM', 'FCM', 'Spectral', 'GMM'};
algorithms =  {'Kmeans', 'SOM', 'Spectral'};
fileList = dir(fullfile(InputDir, '*.mat'));
for i = 1:length(fileList)
   load(fullfile(fileList(i).folder, fileList(i).name));
   fileNumber = fileList(i).name(length('ImsAndTruths')+1 : end - length('.mat'));
   for j = 1:length(algorithms)
       outputPath = fullfile(OutputDir, algorithms{j});
       if exist(outputPath, 'dir') ~= 7
           mkdir(outputPath);
       end
       outputFile = fullfile(outputPath, strcat(fileNumber, 'Seg.mat'));
       if exist(outputFile, 'file') == 2
           continue
       end
       [~, CCIm] = MyClust(Im, 'Algorithm', algorithms{j}, ...
            'NumClusts', length(unique(Seg1)), 'ImType', 'RGB');
       save(outputFile, 'CCIm');
   end
end