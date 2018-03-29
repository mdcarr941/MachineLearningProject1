

function oce = martinIndex(groundTruth,ClusterIm)
%oce = martinIndex(groundTruth,ClusterIm) inpute groundTruth and the
%Clustered image that you are comparing to ground truth
% martin index code
% Dylan Stewart
% Project 1 CAP 6610
maxLabelGT = max(groundTruth(:));
%Calculate W_j
totalLabeled = sum(sum(groundTruth>0));
sizeWeight = zeros(1,maxLabelGT);
for seg = 1:maxLabelGT
    sizeWeight(seg) = sum(sum(groundTruth==seg))/totalLabeled;
end

%calculate W_ji
maxLabelCluster = max(ClusterIm(:));
W = zeros(maxLabelCluster,maxLabelGT);
for row = 1:maxLabelGT
       for col = 1:maxLabelCluster
        delt = deltaFunc(groundTruth==row,ClusterIm==col);
        bWeight = sum(sum(ClusterIm==col));
        
        totalDelta = 0;
        for k = 1:maxLabelCluster
            totalDelta = totalDelta+deltaFunc(groundTruth==row,ClusterIm==k)*sum(sum((ClusterIm==k)));
        end
        
        W(row,col) = delt*bWeight/totalDelta;
       end
end

% calculate index
sumOutside = 0;
for jj = 1:maxLabelGT
    sumInside = 0;
    for ii = 1:maxLabelCluster
        n = sum(sum((groundTruth==jj)&(ClusterIm==ii)));
        d = sum(sum((groundTruth==jj)|(ClusterIm==ii)));
        sumInside = 1-(n*W(jj,ii)/d);
    end
    sumOutside = sumOutside+sumInside*sizeWeight(jj);
end

if isnan(sumOutside)
    sumOutside = 0;
end

oce = sumOutside;




%delta function
    function delt = deltaFunc(A,B)
        Delt = A&B;
        sumDelt = sum(Delt(:));
        if sumDelt==0
            delt = 1;
        else
            delt = 0;
        end
    end
end