% An implementation of the OCE algorithm, used for cluster algorithm
% evaluation.
%
% Syntax: OCE = EvalClustRGB(CCIm, GrTruth)
% 
% Inputs:
%     CCIm - A labeled image, i.e. an L by M by N array, where L is the
%         number of labels.
%     GrTruth - The ground truth segmentation, an M by N matrix with
%         unsigned integer entries from 1 to L.
%     
% Output:
%     OCE - A measure of how closely CCIm matches GrTruth. 0 <= OCE <= 1
%
% Author: Matthew Carr

function OCE = EvalClustRGB(CCIm, GrTruth)
    m = size(CCIm, 2);
    n = size(CCIm, 3);
    CCImMod = zeros(m, n);
    for k = 1:size(CCIm, 1)
        new = squeeze(CCIm(k,:,:));
        new(new == 1) = k;
        CCImMod = CCImMod + new;
    end
    OCE = min(PartialError(CCImMod, GrTruth), PartialError(GrTruth, CCImMod));
end

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
        W(j,:) = W(j,:) ./ sum(W(j,:));
        Wvec(j) = sum(sum(A == j));
    end
    Wvec = Wvec ./ sum(Wvec);
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