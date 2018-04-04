%% An implementation of the Object Consistency Error (OCE) algorithm.
%
% Syntax: OCE = EvalClustRGB(CCIm, GrTruth)
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

function OCE = EvalClustRGB(CCIm, GrTruth)
    % If CCIm has more than 2 dimensions, convert it to a labeled image.
    if (length(size(CCIm)) > 2)
        CCIm = Deflate(CCIm);
    end
    
    % Resample the ground truth if it does not have the same size as CCIm.
    CCImSz = size(CCIm);
    if any(CCImSz ~= size(GrTruth))
        GrTruth = imresize(GrTruth, CCImSz);
    end
    
    OCE = min(PartialError(CCIm, GrTruth), PartialError(GrTruth, CCIm));
end

%% Calculate the partial error between two labeled images.
function err = PartialError(A, B)
    M = length(unique(A));
    N = length(unique(B));
    W = zeros(M, N);
    Wvec = zeros(M);
    for j = 1:M
        for i = 1:N
            if ~any(any(A == j & B == i)), continue, end
            W(j, i) = sum(sum(B == i));
        end
        W(j,:) = W(j,:) ./ (sum(W(j,:)) + eps);
        Wvec(j) = sum(sum(A == j));
    end
    Wvec = Wvec ./ (sum(Wvec) + eps);
    
    err = 0;
    for j = 1:M
        sub = 0;
        for i = 1:N
            sub = sub + sum(sum(A == j & B == i)) ...
                      / sum(sum(A == j | B == i)) * W(j,i);
        end
        err = err + (1 - sub) * Wvec(j);
    end
end