function doRho(kernel, stimProfile, stimNoise)
%{
Plot psychometric performance based on the kernel
%}

    reps = 10000;
    setUpFigure(1, kernel, 'Behavioral Performance Consequences for Rho', ...
        {sprintf('%d repetions per condition', reps),...
        sprintf('Stim noise factor: %.2f', stimNoise),...
        sprintf('Opto Noise: 0.05:-0.002:-0.075')});
    
    stimValues = 0.05:0.0025:0.10;
    numValues = length(stimValues);
    stimProfiles = (stimProfile' * stimValues)';
    
    % set the threshold to the midpoint stimulus
    if mod(numValues, 2) > 0
        threshold = sum(kernel .* stimProfiles(floor(numValues / 2) + 1, :));
    else
        threshold = sum(kernel .* (stimProfiles(numValues / 2, :) + stimProfiles(numValues / 2 + 1, :)) / 2);
    end
    
    rhos = zeros(11, 11);
    n = zeros(11, 11);
    for optoNoise = 0.05:-0.002:-0.075
        hits = zeros(1, length(stimValues));
        noStimHits = zeros(1, length(stimValues));
        for s = 1:length(stimValues)
            [hits(s), noStimHits(s), rho] = doOneStimulus(s, kernel, threshold, stimProfiles, stimNoise, optoNoise, reps);
            if ~isempty(rho)
                fprintf('%d: stim %.2f, noStim %.2f, rho %.2f\n', s, hits(s), noStimHits(s), rho);
                stimBin = 12 - (round(hits(s) * 10) + 1);
                noStimBin = round(noStimHits(s) * 10) + 1;
                rhos(stimBin, noStimBin) = rhos(stimBin, noStimBin) + rho;
                n(stimBin, noStimBin) = n(stimBin, noStimBin) + 1;
            end
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
    
        if exist('ax', 'var')
            delete(ax);
        end
        axes('Position', [0.15 0.1 0.7 0.6]);
        heatmap(rhos ./ n);
        xlabel('Behavioral Performance Unstimulated Trials');
        ylabel('Behavioral Performance Stimulated Trials');
        title('Effect of Optogenetic Behavioral Impact on Rho');
        labels = {'0.0', '0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1.0'};
        ax = gca;
        ax.XData = labels;
        ax.YData = fliplr(labels);
        ax.CellLabelFormat = '%.2f';
        drawnow;
    end
end

%%
function [stimHits, noStimHits, rho] = doOneStimulus(index, kernel, threshold, stimProfiles, noiseFactor, optoPower, reps)

    distName = 'Binary';
    bins = length(kernel);
    posKernel = zeros(1, bins);
    negKernel = zeros(1, bins);
    numPos = 0;
    numNeg = 0;
    noStimHits = 0;
    stimMean = zeros(1, reps);
    stimSD = zeros(1, reps);
    for r = 1:reps
        noisyStim = profilePlusNoise(stimProfiles(index, :), noiseFactor, 0.0, 'Binary'); % zero optoPower for noStim test
        % response without opto stim
        if sum(kernel .* noisyStim) > threshold
            noStimHits = noStimHits + 1;
        end
        % response with opto stim
        optoStim = getRandom(optoPower, abs(optoPower) / 2, distName, bins);
        stimMean(r) = mean(optoStim);
        stimSD(r) = std(optoStim);
        response = sum(kernel .* (noisyStim + optoStim));
        if response >= threshold
            posKernel = posKernel + optoStim;
            numPos = numPos + 1;
        else
            negKernel = negKernel + optoStim;
            numNeg = numNeg + 1;
        end
    end
    noStimHits = noStimHits / reps;
    stimHits = numPos / reps;

    if numPos > 0 && numNeg > 0
        r = corrcoef(kernel, posKernel / numPos - negKernel / numNeg);
        rho = r(1, 2);
        if isnan(rho)                                           % zero noise makes zero pos/neg kernels
            rho = [];
        end
    else
        rho = [];
    end
end

