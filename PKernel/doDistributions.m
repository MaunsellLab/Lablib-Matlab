function doDistributions(kernel, noiseFactor)
%{
The random stimulus on every trial (uniform, binary, Gaussian) has a mean of 1.0, so it adjusts the gain of the 
kernel randomly over time. To keep responses balanced at 50% regardless of the kernel, we find the expected value of 
the kernel and treat that as our criterion for a hit.

The takeaway from this plot is that the results aren't too much affected by the distribution of the stimulus noise.
If the mean and variance of the stimulus noise is the same, the performance is pretty much the same.  That makes
some sense, because the variance is really the signal that we are trying to measure.
%}
    figure(1);
    clf;
    subplot(4, 3, 1, 'replace');
    plot(kernel);
    title('Actual Kernel');
    drawnow;
   
    doOneDist(kernel, noiseFactor, 'Uniform');
    doOneDist(kernel, noiseFactor, 'Binary');
    doOneDist(kernel, noiseFactor, 'Gaussian');
end

%%
function doOneDist(kernel, noiseFactor, distName)

    threshold = sum(kernel);
    bins = length(kernel);
    posKernel = zeros(1, bins);
    negKernel = zeros(1, bins);
    posShuffle = zeros(1, bins);
    negShuffle = zeros(1, bins);
    numPos = 0;
    numNeg = 0;
    reps = 50000;
    stimMean = zeros(1, reps);
    stimSD = zeros(1, reps);
    stim = getRandom(distName, bins);          	% preload for shuffle
    for r = 1:reps
        shuffle = stim;                         % take last stim to use in shuffle
        stim = getRandom(distName, bins);
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
    col = find(ismember({'Uniform', 'Binary', 'Gaussian'}, distName) == 1);
    subplot(4, 3, 3 + col, 'replace');
    sigLevel = 2.0 * std(posShuffle / numPos - negShuffle / numNeg);
    fill([0, bins, bins, 0],[-sigLevel, -sigLevel, sigLevel, sigLevel], [0.95 0.95 0.95], 'LineStyle', ':');
    hold on;
    plot(posKernel / numPos - negKernel / numNeg, 'k');
    title(sprintf('%s Kernel (n=%d)', distName, numPos + numNeg));
    rho = corrcoef(kernel, posKernel / numPos - negKernel / numNeg);
    displayText({sprintf('stim mean: %.3f', mean(stimMean)), sprintf('stim SD: %.3f', mean(stimSD)), ...
        sprintf('r = %.4f', rho(1, 2))});
    subplot(4, 3, 6 + col, 'replace');
    plot(posKernel / numPos);
    title(sprintf('%s + Kernel (n=%d)', distName, numPos));    
    rho = corrcoef(kernel, posKernel);
    displayText(sprintf('r = %.3f', rho(1, 2)));
    
    subplot(4, 3, 9 + col, 'replace');
    plot(negKernel / numNeg);
    title(sprintf('%s - Kernel (n=%d)', distName, numNeg));    
    rho = corrcoef(kernel, negKernel);
    displayText(sprintf('r = %.3f', rho(1, 2)));
    
    drawnow;
end

%%
function stim = getRandom(distName, bins)
    switch distName                                      % make distributions from 0:2
        case 'Uniform'
            stim = rand(1, bins) * 2.0;
        case 'Binary'
            stim = randi([0 1], [1, bins]) + 0.5;
        case 'Gaussian'
            stim = randn(1, bins) / 2 + 1.0;
        otherwise
            error('Unrecognized column value');
    end
end

%%
function displayText(theText)

    lim = axis;
    text(lim(1) + 0.05 * (lim(2) - lim(1)), lim(4) - 0.025 * (lim(4) - lim(3)), theText, 'VerticalAlignment', 'top');
end