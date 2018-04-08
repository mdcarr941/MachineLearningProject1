%% This function computes the Object Consistency Error between two segmentations,
% not to be confused with the related but separate notion: the Martin Index.
% 
% Inputs:
% 	A - An N by M matrix with values in 1:length(unique(A)).
%   B - An N by M matrix with values in 1:length(unique(B)).
%
% Output:
% 	OCE - A double. The Object Consistency Error between the two segmentations.
%
% Author: Matthew Carr
function OCE = MyMartinIndex6(A, B)
	OCE = min(PartialError(A, B), PartialError(B, A));
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
                      / (sum(sum(A == j | B == i)) + eps) * W(j,i);
        end
        err = err + (1 - sub) * Wvec(j);
    end
end