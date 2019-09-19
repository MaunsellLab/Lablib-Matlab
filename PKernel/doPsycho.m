function doPsycho(kernel, stimNoise, optoPower)
%{

Plot psychometric performance based on the kernel

%}

    reps = 10000;
    setUpFigure(1, kernel, 'Behavioral Performance', {sprintf('%d repetions per condition', reps),...
        sprintf('Stim noise factor: %.2f', stimNoise)});
    
    % set up the stimuli
    numBins = length(kernel);
    stimProfile = zeros(1, numBins);
    midPoint = numBins / 2;
    stimProfile(midPoint:midPoint + 20) = 1.0;
%     stimValues = [0.03, 0.04, 0.05, 0.075, 0.1, 0.2];
    stimValues = 0.05:0.01:0.10;
    numValues = length(stimValues);
    stimProfiles = (stimProfile' * stimValues)';
    
    % set the threshold to the midpoint stimulus
    if mod(numValues, 2) > 0
        threshold = sum(kernel .* stimProfiles(numValues / 2 + 1, :));
    else
        threshold = sum(kernel .* (stimProfiles(numValues / 2, :) + stimProfiles(numValues / 2 + 1, :)) / 2);
    end
    
    % plot stimulus profiles
    hs = subplot(4, 3, 4, 'replace');
    plot(stimProfiles');
    ylStim = ylim;
    title('Stimuli');
    % plot examples of the minimum stimulus plus stimulus noise
    numDemo = 10;
    noisyProfiles = zeros(numDemo, numBins);
    for p = 1:numDemo
        noisyProfiles(p, :) = profilePlusNoise(stimProfiles(1, :), stimNoise, 0.0);
    end
    hn = subplot(4, 3, 5, 'replace');
    plot(noisyProfiles', 'b');
    ylNoise = ylim;
    title('Min Stim+Noise');
    % plot examples of the minimum stimulus plus opto noise
    numDemo = 10;
    noisyProfiles = zeros(numDemo, numBins);
    for p = 1:numDemo
        noisyProfiles(p, :) = profilePlusNoise(stimProfiles(1, :), 0.0, optoPower);
    end
    ho = subplot(4, 3, 6, 'replace');
    plot(noisyProfiles', 'b');
    ylOpto = ylim;
    title('Min Stim+Opto');
    % scale the stimulus plots to the same height
    yMax = max([ylNoise, ylOpto, ylStim]);
    yMin = min([ylNoise, ylOpto, ylStim]);
    ylim(hs, [yMin, yMax]);
    ylim(hn, [yMin, yMax]);
    ylim(ho, [yMin, yMax]);
    
    hits = zeros(1, length(stimValues));
    noStimHits = zeros(1, length(stimValues));
    for s = 1:length(stimValues)
        [hits(s), noStimHits(s), rho] = doOneStimulus(s, kernel, threshold, stimProfiles, stimNoise, optoPower, reps);
    end
    % plot the psychometric function
    subplot(4, 3, 2, 'replace');
    semilogx(stimValues, hits, '-or', 'MarkerSize', 6, 'MarkerEdgeColor', 'r', ...
        'MarkerFaceColor', [1,0.25,0.25]);
    hold on;
    semilogx(stimValues, noStimHits, '-ob', 'MarkerSize', 6, 'MarkerEdgeColor', 'b', ...
        'MarkerFaceColor', [0.25,0.25,1.0]);
	axis([-inf, inf, 0, 1]);
    title('Behavior');
end

%%
function [stimHits, noStimHits, rho] = doOneStimulus(index, kernel, threshold, stimProfiles, noiseFactor, optoPower, reps)

    distName = 'Binary';
    bins = length(kernel);
    posKernel = zeros(1, bins);
    negKernel = zeros(1, bins);
    posShuffle = zeros(1, bins);
    negShuffle = zeros(1, bins);
    numPos = 0;
    numNeg = 0;
    noStimHits = 0;
    stimMean = zeros(1, reps);
    stimSD = zeros(1, reps);
    optoStim = getRandom(optoPower, abs(optoPower) / 2, distName, bins);        % preload for shuffle
    for r = 1:reps
        noisyStim = profilePlusNoise(stimProfiles(index, :), noiseFactor, 0.0); % zero optoPower for noStim test
        % response without opto stim
        if sum(kernel .* noisyStim) > threshold
            noStimHits = noStimHits + 1;
        end
        % response with opto stim
        shuffle = optoStim;                                     % take last stim to use in shuffle
        optoStim = getRandom(optoPower, abs(optoPower) / 2, distName, bins);
        stimMean(r) = mean(optoStim);
        stimSD(r) = std(optoStim);
        response = sum(kernel .* (noisyStim + optoStim));
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
    noStimHits = noStimHits / reps;
    stimHits = numPos / reps;

    if numPos > 0 && numNeg > 0
        plotText = {sprintf('H: %d M: %d', numPos, numNeg)};
        titleText = sprintf('%s', distName);
        shuffleSEM = sqrt(std(posShuffle / numPos)^2 + std(negShuffle / numNeg)^2);
        rho = doOnePlot(index + 6, kernel, posKernel / numPos - negKernel / numNeg, plotText, titleText, shuffleSEM);
        drawnow;
    else
        rho = 0;
    end
end

%%
function noisyProfile = profilePlusNoise(stimProfile, stimNoise, optoNoise)
        
    noisyProfile = stimProfile * exp((rand - 0.5) * stimNoise) + ...
        getRandom(0.0, 1.0, 'Binary', length(stimProfile)) * optoNoise;
end

