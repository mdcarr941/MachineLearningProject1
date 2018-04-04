function CCImMod = Deflate(CCIm)
    m = size(CCIm, 2);
    n = size(CCIm, 3);
    CCImMod = zeros(m, n);
    for k = 1:size(CCIm, 1)
        new = squeeze(CCIm(k,:,:));
        new(new == 1) = k;
        CCImMod = CCImMod + new;
    end
end