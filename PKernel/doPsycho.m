function doPsycho(kernel, stimNoise, optoPower)
%{

Plot psychometric performance based on the kernel

%}

% NEED TO PLOT UNSTIMULUATED AND STIMULATED TRIALS

    reps = 1000;
    setUpFigure(1, kernel, 'Behavioral Performance', {sprintf('%d repetions per condition', reps),...
        sprintf('Stim noise factor: %.2f', stimNoise)});
    
    % set up the stimuli
    numBins = length(kernel);
    stimProfile = zeros(1, numBins);
    midPoint = numBins / 2;
    stimProfile(midPoint:midPoint + 20) = 1.0;
    stimValues = [0.03125, 0.0625, 0.125, 0.25, 0.5, 1.0];
    stimProfiles = stimProfile' * stimValues;
    
    % set the threshold to the midpoint stimulus
    threshold = sum(kernel .* stimProfiles(:, 3));

    subplot(4, 3, 6, 'replace');
    plot(stimProfiles);
    title('Stimulus Profiles');
    
    hits = zeros(1, length(stimValues));
    noStimHits = zeros(1, length(stimValues));
    for s = 1:length(stimValues)
        [hits(s), noStimHits(s)] = doOneStimulus(s, kernel, threshold, stimProfiles, stimNoise, optoPower, 'Binary', reps);
    end
    subplot(4, 3, 5, 'replace');
    p = semilogx(stimValues, hits, '-or', 'MarkerSize', 6, 'MarkerEdgeColor', 'r', ...
        'MarkerFaceColor', [1,0.25,0.25]);
    hold on;
    p = semilogx(stimValues, noStimHits, '-ob', 'MarkerSize', 6, 'MarkerEdgeColor', 'b', ...
        'MarkerFaceColor', [0.25,0.25,1.0]);
	axis([-inf, inf, 0, 1]);
    title('Behavior');
end

%%
function [stimHits, noStimHits] = doOneStimulus(index, kernel, threshold, stimProfiles, noiseFactor, optoPower, distName, reps)

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
    optoStim = getRandom(optoPower, abs(optoPower) / 2, distName, bins);          	% preload for shuffle
    for r = 1:reps
     	noisyStim = stimProfiles(:, index)' + (rand(1, bins) * noiseFactor);        % visual stim always Gaussion noise
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
%     col = find(ismember({'Uniform', 'Binary', 'Gaussian'}, distName) == 1);
    
    if numPos > 0 && numNeg > 0
        plotText = {sprintf('stim mean: %.3f', mean(stimMean)), sprintf('stim SD: %.3f', mean(stimSD))};
        titleText = sprintf('%s', distName);
        shuffleSEM = sqrt(std(posShuffle / numPos)^2 + std(negShuffle / numNeg)^2);
        doOnePlot(index + 6, kernel, posKernel / numPos - negKernel / numNeg, plotText, titleText, shuffleSEM);
    end
    noStimHits = noStimHits / reps;
    stimHits = numPos / reps;
% 	doOnePlot(col + 3, kernel, posKernel / numPos, cell(0), sprintf('%s Pos. (n=%d)', distName, numPos));
%     doOnePlot(col + 6, kernel, negKernel / numNeg, cell(0), sprintf('%s Neg. (n=%d)', distName, numNeg));

    drawnow;
end

