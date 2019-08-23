function doVariance(kernel, noiseFactor)
%{
The random stimulus on every trial (uniform, binary, Gaussian) has a mean of 1.0, so it adjusts the gain of the 
kernel randomly over time. To keep responses balanced at 50% regardless of the kernel, we find the expected value of 
the kernel and treat that as our criterion for a hit.

The takeaway from this plot is that the results aren't too much affected by the distribution of the stimulus noise.
If the mean and variance of the stimulus noise is the same, the performance is pretty much the same.  That makes
some sense, because the variance is really the signal that we are trying to measure.
%}

    setUpFigure(2, kernel, 'Effects of Stimulus Variance');
    for s = 1:9
        doOneSD(s, kernel, noiseFactor, 'Binary');
    end
end

%%
function doOneSD(sIndex, kernel, noiseFactor, distName)

    SDs = [8.0, 4.0, 2.0, 1.0, 0.5, 0.4, 0.3, 0.02, 0.01];
    threshold = sum(kernel);
    bins = length(kernel);
    posKernel = zeros(1, bins);
    negKernel = zeros(1, bins);
    posShuffle = zeros(1, bins);
    negShuffle = zeros(1, bins);
    numPos = 0;
    numNeg = 0;
    reps = 10000;
    stimMean = zeros(1, reps);
    stimSD = zeros(1, reps);
    stim = getRandom(1.0, SDs(sIndex), distName, bins);          	% preload for shuffle
    for r = 1:reps
        shuffle = stim;                         % take last stim to use in shuffle
        stim = getRandom(1.0, SDs(sIndex), distName, bins);
        stimMean(r) = mean(stim);
        stimSD(r) = std(stim);
        product = kernel .* stim;
        noise = randn(1, bins) * noiseFactor + 1.0;
        product = product .* noise;
        if sum(product) >= threshold
            posKernel = posKernel + stim;
            posShuffle = posShuffle + shuffle;
            numPos = numPos + 1;
        else
            negKernel = negKernel + stim;
            negShuffle = negShuffle + shuffle;
            numNeg = numNeg + 1;
        end
    end
    subplot(4, 3, sIndex + 3, 'replace');
    sigLevel = 2.0 * std(posShuffle / numPos - negShuffle / numNeg);
    fill([0, bins, bins, 0],[-sigLevel, -sigLevel, sigLevel, sigLevel], [0.95 0.95 0.95], 'LineStyle', ':');
    hold on;
    plot(posKernel / numPos - negKernel / numNeg, 'k');
    title(sprintf('%s Kernel (n=%d)', distName, numPos + numNeg));
    rho = corrcoef(kernel, posKernel / numPos - negKernel / numNeg);
    displayText({sprintf('stim mean: %.3f', mean(stimMean)), sprintf('stim SD: %.3f', mean(stimSD)), ...
        sprintf('r = %.4f', rho(1, 2))});
    drawnow;
end

%%
function displayText(theText)

    lim = axis;
    text(lim(1) + 0.05 * (lim(2) - lim(1)), lim(4) - 0.025 * (lim(4) - lim(3)), theText, 'VerticalAlignment', 'top');
end