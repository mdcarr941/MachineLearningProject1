function [ClusterIm, CCIm] = MyClust(Im, varargin)
    Algorithm = '';
    ImType = '';
    NumClusts = -1;
    
    % Extract input parameters from varargin.
    for i = 1:length(varargin)
        if strcmp(varargin(i), 'Algorithm')
            Algorithm = varargin{i + 1};
            i = i + 1;
        elseif strcmp(varargin(i), 'ImType')
            ImType = varargin{i + 1};
            i = i + 1;
        elseif strcmp(varargin(i), 'NumClusts')
            NumClusts = varargin{i + 1};
            i = i + 1;
        end
    end
    
    % Do some trivial input validation.
    if ~(strcmp(ImType, 'RGB') || strcmp(ImType, 'Hyper'))
        error('The ImType argument must be either "RGB" or "Hyper".');
    end
    
    if NumClusts <= 0
        error('The NumClusts argument must be a positive integer.');
    end
    
    % Call the named algorithm or error out.
    if strcmp(Algorithm, 'Kmeans')
        [ClusterIm, CCIm] = MyKmeans(Im, ImType, NumClusts);
    elseif strcmp(Algorithm, 'SOM')
        [ClusterIm, CCIm] = MySOM(Im, ImType, NumClusts);
    elseif strcmp(Algorithm, 'FCM')
        [ClusterIm, CCIm] = MyFCM(Im, ImType, NumClusts);
    elseif strcmp(Algorithm, 'Spectral')
        [ClusterIm, CCIm] = MySpectral(Im, ImType, NumClusts);
    elseif strcmp(Algorithm, 'GMM')
        [ClusterIm, CCIm] = MyGMM(Im, ImType, NumClusts);
    else
        error('The Algorithm argument must be one of "Kmeans", "SOM", "FCM", "Spectral", or "GMM".');
    end
end