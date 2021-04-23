function RTHistogram(dParams, file, trials, indices)
% plot the reaction time histogram for task plugin data
%
  if isempty(indices.correct)
   correctRTs = -10000;                  % make sure we don't get an empty matrix from histc
  else
  correctRTs = [trials(indices.correct).reactTimeMS];
  end
  if isempty(indices.fa)
    wrongRTs = -10000;                  % make sure we don't get an empty matrix from histc
  else
    wrongRTs = [trials(indices.fa).reactTimeMS];
  end
  if isempty(indices.miss)
    missRTs = -10000;                  % make sure we don't get an empty matrix from histc
  else
    allMissRTs = [trials(indices.miss).reactTimeMS];
    missRTs = allMissRTs(allMissRTs > 0);
  end
  subplot(dParams.plotLayout{:}, 7);
  cla;
  hold on;
  if isfield(file, 'responseLimitMS')
    timeLimit = min(file.responseLimitMS, 5000);
  elseif isfield(file, 'reactMS')
    timeLimit = min(file.reactMS, 5000);
  else
    timeLimit = 1000;
  end
  edges = linspace(-1000, timeLimit, dParams.RTBins);
  nCorrect = histc(correctRTs, edges);
  nWrong = histc(wrongRTs, edges);
  nMiss = histc(missRTs, edges);
  if sum(nCorrect) + sum(nWrong) + sum(nMiss) > 0
    binSize = edges(2) - edges(1);
    bH = bar(edges + binSize / 2, [nCorrect(:), nMiss(:), nWrong(:)], 'stacked');
    set(bH, 'barWidth', 1, 'lineStyle', 'none');
    set(bH(1), 'FaceColor', [0 0 0.6]);
    set(bH(2), 'FaceColor', [0.6 0 0]);
    set(bH(3), 'faceColor', [0.6 0 0]);
    if max([nWrong, nCorrect, nMiss] > 50)         % re-bin on next plot?
       dParams.RTBins = min([dParams.RTBins * 2, 100]);
    end
    yLimits = get(gca, 'YLim');                % vertical line at stimulus on
    plot([0 0], yLimits, 'k');
    if isfield(file, 'tooFastMS')
        llH = plot(double(file.tooFastMS) * [1 1], yLimits, 'k--');
        set(llH, 'Color', 0.5 * [0 1 0]);
    end
    if isfield(file, 'rewardedLimitMS')
      llH = plot(double(file.rewardedLimitMS) * [1 1], yLimits, 'r--');
      set(llH, 'Color', 0.5 * [1 0 0]);
    elseif isfield(file, 'reactMS')
      llH = plot(double(file.reactMS) * [1 1], yLimits, 'r--');
      set(llH, 'Color', 0.5 * [1 0 0]);
    end
    if isfield(file, 'responseLimitMS')
        llH = plot(double(file.responseLimitMS) * [1 1], yLimits, 'r--');
        set(llH, 'Color', 0.5 * [1 0 0]);
    end
  end
  set(gca, 'XLim', [-1000 timeLimit]);
  xlabel('Time Relative to Stimulus');
  title('Reaction Times');
end
  
