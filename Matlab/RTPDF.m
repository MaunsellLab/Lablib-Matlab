function RTPDF(dParams, file, trials, indices)
% Plot RT PDF for task plugins
%
  if isempty(indices.correct)
     correctRTs = -10000;                  % make sure we don't get an empty matrix from histc'
  else
     correctRTs = [trials(indices.correct).reactTimeMS];
  end
  if isempty(indices.fa)
    wrongRTs = -10000;                    % make sure we don't get an empty matrix from histc
  else
    wrongRTs = [trials(indices.fa).reactTimeMS];
  end
  if isempty(indices.miss)
    missRTs = -10000;                    % make sure we don't get an empty matrix from histc
  else
    missRTs = [trials(indices.miss).reactTimeMS];
  %     missRT(missRTs < 0) = 100000;        % include misses in count, but don't let them display on plot
  end
  subplot(dParams.plotLayout{:}, 4);
  cla;
  cdfplot([correctRTs wrongRTs missRTs]);
  if isfield(file, 'responseLimitMS')
    timeLimit = min(file.responseLimitMS, 5000);
  elseif isfield(file, 'reactMS')
    timeLimit = min(file.reactMS, 5000);
  else
    timeLimit = 1000;
  end
  set(gca, 'XLim', [-1000 timeLimit], 'YLim', [0 1]);
  hold on;
  yLimits = get(gca, 'YLim');
  plot([0 0], yLimits, 'k');
  if isfield(file, 'tooFastMS')
    plot(double(file.tooFastMS) * [1 1], yLimits, '--', 'Color', 0.5 * [0 1 0]);
  end
  if isfield(file, 'rewardedLimitMS')
   plot(double(file.rewardedLimitMS) * [1 1], yLimits, '--', 'Color', 0.5 * [1 0 0]);
  elseif isfield(file, 'reactMS')
     plot(double(file.reactMS) * [1 1], yLimits, '--', 'Color', 0.5 * [1 0 0]);
  end
  if isfield(file, 'responseLimitMS')
    plot(double(file.responseLimitMS) * [1 1], yLimits, '--', 'Color', 0.5 * [1 0 0]);
  end
  if isfield(file, 'kernelRTMinMS')
    plot(double(file.kernelRTMinMS) * [1 1], yLimits, ':', 'Color', 0.5 * [0 1 0]);
  end
  if isfield(file, 'kernelRTMaxMS')
    plot(double(file.kernelRTMaxMS) * [1 1], yLimits, ':', 'Color', 0.5 * [1 0 0]);
  end

  title('Cumulative Reaction Times');
  xlabel('');
  ylabel('');
end
