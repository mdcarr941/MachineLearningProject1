% An implementation of the Object Consistency Error (OCE) algorithm.
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
% Author: Matthew Carr and Dylan Stewart

function OCE = EvalClustHyper(ClusterIm, GrTruth)

    
    OCE = min(PartialError(ClusterIm, GrTruth), PartialError(GrTruth, ClusterIm));
end

function err = PartialError(A, B)
    M = length(unique(A>0));
    N = length(unique(B>0));
    W = zeros(M, N);
    Wvec = zeros(M,1);
    for j = 1:M
        for i = 1:N
            if ~any(any(A == j & B == i)), continue, end
            W(j, i) = sum(sum(B == i));
        end        
        W(j,:) = W(j,:) ./ (sum(W(j,:))+eps);
        Wvec(j) = sum(sum(A == j));
    end
    Wvec = Wvec ./ (eps+sum(Wvec));
    
    err = 0;
    for j = 1:M
        sub = 0;
        for i = 1:N
            sub = sub + sum(sum(A == j & B == i)) ...
                      / ((sum(sum(A == j | B == i)) * W(j,i))+eps);
        end
        err = err + (1 - sub) * Wvec(j);
    end
end