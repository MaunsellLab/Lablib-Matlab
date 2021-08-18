%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Trial outcomes over the time course of individual trials %%%

function outcomesOverTrial(dParams, plotIndex, file, trials, indices, trialStructs)

  preStimMS = [trialStructs(:).preStimMS];
  hitTimes = preStimMS(indices.correct);
  hitRTs = [trials(indices.correct).reactTimeMS];    % release relative to stimTime on hits
  faTimes = preStimMS(indices.fa);
  faRTs = [trials(indices.fa).reactTimeMS];          % response relative to stimTime on FAs
  missTimes = preStimMS(indices.miss);
  if isempty(hitTimes)
    hitTimes = -10000;
    hitRTs = 0;
  end
  if isempty(faTimes)
     faTimes = -10000;
     faRTs = 0;
  end
  if isempty(missTimes)
     missTimes = -10000;
  end
  releaseTimes = [(hitTimes + hitRTs), (faTimes + faRTs)];
  subplot(dParams.plotLayout{:}, plotIndex);
  cla;
  hold on;
  trialBins = max(10, length(trials) / 20);                   	% 10 or more bins
  set(gca, 'XLim', [1 trialBins]);
  if isfield(file, 'responseLimitMS')
    timeRangeMS = max(file.preStimMaxMS + file.responseLimitMS, 1);
    minStimXPos = file.preStimMinMS / timeRangeMS * (trialBins - 1) + 1;
    maxStimXPos = file.preStimMaxMS / timeRangeMS * (trialBins - 1) + 1;
    if minStimXPos >= maxStimXPos
        if maxStimXPos >= trialBins
            maxStimXPos = trialBins;
            set(gca,'XTick', [1, trialBins]);
            set(gca,'XTickLabel',{'0', sprintf('%d', timeRangeMS)});
        else
            set(gca,'XTick', [1, maxStimXPos, trialBins]);
            set(gca,'XTickLabel',{'0', sprintf('%d', file.preStimMaxMS), sprintf('%d', timeRangeMS)});
        end
        minStimXPos = maxStimXPos;
    else
        if maxStimXPos >= trialBins
            maxStimXPos = trialBins;
            set(gca,'XTick', [1, minStimXPos, trialBins]);
            set(gca,'XTickLabel',{'0', sprintf('%d', file.preStimMinMS), sprintf('%d', timeRangeMS)});
        else
            set(gca,'XTick', [1, minStimXPos, maxStimXPos, trialBins]);
            set(gca,'XTickLabel',{'0', sprintf('%d', file.preStimMinMS), sprintf('%d', file.preStimMaxMS), ...
                sprintf('%d', timeRangeMS)});
        end
    end
  else
    timeRangeMS = max(file.preStimMaxMS, 1);
    minStimXPos = file.preStimMinMS / timeRangeMS * (trialBins - 1) + 1;
    maxStimXPos = trialBins;
    set(gca,'XTick', [1, trialBins]);
    set(gca,'XTickLabel',{'0', sprintf('%d', timeRangeMS)});  
  end
%   binWidth = timeRangeMS / trialBins;                            % binWidth in MS
%   edges = [0.0, linspace(0.5 * binWidth, timeRangeMS - 0.5 * binWidth, trialBins), timeRangeMS];
%   counts = hist(hitTimes, edges);
%   nHits = [counts(1) + counts(2), counts(3:end-2), counts(end-1) + counts(end)];
%   counts = hist(faTimes, edges);
%   nFAs = [counts(1) + counts(2), counts(3:end-2), counts(end-1) + counts(end)];
%   counts = hist(missTimes, edges);
%   nMisses = [counts(1) + counts(2), counts(3:end-2), counts(end-1) + counts(end)];
%   nTotal = nHits + nFAs + nMisses;
%   counts = hist(releaseTimes, edges);
%   nReleases = [counts(1) + counts(2), counts(3:end-2), counts(end-1) + counts(end)];
  
  edges = linspace(0, timeRangeMS, trialBins);
  hitCounts = histcounts(hitTimes, edges);
  faCounts = histcounts(faTimes, edges);
  missCounts = histcounts(missTimes, edges);
  nTotal = hitCounts + faCounts + missCounts;
  if isempty(find(nTotal > 0, true, 'first'))           % no counts yet?
     return;
  end
  earlyCounts = histcounts(releaseTimes, edges);

  pHits = hitCounts ./ nTotal;                          % proportions of hits, FAs and misses
  pFAs = faCounts ./ nTotal;
  pMisses = missCounts ./ nTotal;
  pEarly = earlyCounts ./ (max(earlyCounts) * 1.25);
  xlabel('Time of stimulus onset (ms)');
  ylabel('Proportion of trials');
  set(gca, 'YLim', [0 1]);
  set(gca,'YTick', [0 1]);
  title('Outcomes Over Trial');

  plot(pHits, 'color', [0.0, 0.7, 0.0], 'lineWidth', 1);
  plot(pFAs, 'color', [0.9, 0.0, 0.0], 'lineWidth', 1);
  plot(pMisses, 'color', [0.6, 0.4, 0.2], 'lineWidth', 1);
  plot(pEarly, 'color', [0.6, 0.6, 0.6], 'lineWidth', 1);
  if maxStimXPos > minStimXPos
    plot([minStimXPos, minStimXPos], [0, 1], 'k:');
  end
  plot([maxStimXPos, maxStimXPos], [0, 1], 'k:');
end
