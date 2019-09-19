function rho = doOnePlot(index, kernel, kData, plotText, titleText, sigLevel)

    bins = length(kData);
    subplot(4, 3, index, 'replace');
    if (nargin > 5)
        fill([0, bins, bins, 0],[-sigLevel, -sigLevel, sigLevel, sigLevel], [0.95 0.95 0.95], 'LineStyle', ':');
        hold on;
    end
    plot(kData, 'k');
    r = corrcoef(kernel, kData);
    rho = r(1, 2);
    plotText{length(plotText) + 1} = sprintf('r = %.2f', rho);
    doPlotText(titleText, plotText);
end