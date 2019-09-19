function doDistributions(kernel, stimProfile, stimNoise)
%{
The random stimulus on every trial (uniform, binary, Gaussian) has a mean of 1.0, so it adjusts the gain of the 
kernel randomly over time. To keep responses balanced at 50% regardless of the kernel, we find the expected value of 
the kernel and treat that as our criterion for a hit.

The takeaway from this plot is that the results aren't too much affected by the distribution of the stimulus noise.
If the mean and variance of the stimulus noise is the same, the performance is pretty much the same.  That makes
some sense, because the variance is really the signal that we are trying to measure.
%}

    reps = 10000;
    setUpFigure(2, kernel, 'Effects of Stimulus Distribution', {sprintf('Noise factor: %.2f', stimNoise),...
        sprintf('%d repetions per condition', reps)});

    doOneDist(kernel, stimProfile, stimNoise, 'Uniform', reps);
    doOneDist(kernel, stimProfile, stimNoise, 'Binary', reps);
    doOneDist(kernel, stimProfile, stimNoise, 'Gaussian', reps);
end

%%
function doOneDist(kernel, stimProfile, stimNoise, distName, reps)

    col = find(ismember({'Uniform', 'Binary', 'Gaussian'}, distName) == 1);
    threshold = sum(kernel);
    bins = length(kernel);
    posKernel = zeros(1, bins);
    negKernel = zeros(1, bins);
    posShuffle = zeros(1, bins);
    negShuffle = zeros(1, bins);
    numPos = 0;
    numNeg = 0;
    stimMean = zeros(1, reps);
    stimSD = zeros(1, reps);
%     stim = getRandom(1.0, 0.5, distName, bins);          	% preload for shuffle
	[~, optoStim] = profilePlusNoise(stimProfile, stimNoise, 0.5, distName);    % preload for shuffle
    for r = 1:reps
        shuffle = optoStim;                         % take last stim to use in shuffle
    	[noisyStim, optoStim] = profilePlusNoise(stimProfile, stimNoise, 0.5, distName);    % preload for shuffle
%        stim = (1.0, 0.5, distName, bins);
        stimMean(r) = mean(optoStim);
        stimSD(r) = std(optoStim);
        response = sum(kernel .* noisyStim);  
%        product = kernel .* stim;
%         switch distName
%             case 'Uniform'
%                 noise = rand(1, bins) * noiseFactor + 1.0;
%             case 'Binary'
%                 noise = randi([0 1], 1, bins) * noiseFactor + 1.0;
%            case 'Gaussian'
%                 noise = randn(1, bins) * noiseFactor + 1.0;
%         end
%         product = product .* noise;
%         if sum(product) >= threshold
        if response >= threshold
            posKernel = posKernel + optoStim;
            posShuffle = posShuffle + shuffle;
            numPos = numPos + 1;
        else
            negKernel = negKernel + optoStim;
            negShuffle = negShuffle + shuffle;
            numNeg = numNeg + 1;
        end
    end
    plotText = {sprintf('stim mean: %.3f', mean(stimMean)), sprintf('stim SD: %.3f', mean(stimSD))};
    titleText = sprintf('%s', distName);
	doOnePlot(col + 3, kernel, posKernel / numPos - negKernel / numNeg, plotText, titleText);
	doOnePlot(col + 6, kernel, posKernel / numPos, cell(0), sprintf('%s Pos. (n=%d)', distName, numPos));
    doOnePlot(col + 9, kernel, negKernel / numNeg, cell(0), sprintf('%s Neg. (n=%d)', distName, numNeg));

    drawnow;
end

