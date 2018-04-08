%% An implementation of the Object Consistency Error (OCE) algorithm.
% 
% Inputs:
%   CCIm - A labeled image, i.e. an L by M by N array, where L is the
%       number of labels.
%   GrTruth - The ground truth segmentation, an M by N matrix with
%       unsigned integer entries from 1 to L. This code assumes that the
%       class labels in GrTruth are sequential (every integer from 1 to
%       L). If this assumption is violated, YMMV.
%     
% Output:
%   OCE - A measure of how closely CCIm matches GrTruth. 0 <= OCE <= 1
%
% Author: Matthew Carr
function OCE = MyClustEvalRGB6(CCIm, GrTruth)

    % If CCIm has more than 2 dimensions, convert it to a labeled image.
    if (length(size(CCIm)) > 2)
        CCIm = Deflate(CCIm);
    end
    
    % Resample the ground truth if it does not have the same size as CCIm.
    CCImSz = size(CCIm);
    if any(CCImSz ~= size(GrTruth))
        GrTruth = imresize(GrTruth, CCImSz);
    end
    
    OCE = MyMartinIndex6(CCIm, GrTruth);
end