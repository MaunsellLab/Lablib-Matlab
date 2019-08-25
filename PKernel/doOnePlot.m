function doOnePlot(index, kernel, kData, plotText, titleText, sigLevel)

    bins = length(kData);
    subplot(4, 3, index + 3, 'replace');
    if (nargin > 6)
        fill([0, bins, bins, 0],[-sigLevel, -sigLevel, sigLevel, sigLevel], [0.95 0.95 0.95], 'LineStyle', ':');
        hold on;
    end
    plot(kData, 'k');
    rho = corrcoef(kernel, kData);
    plotText{length(plotText) + 1} = sprintf('r = %.4f', rho(1, 2));
    doPlotText(titleText, plotText);
end