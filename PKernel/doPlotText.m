function doPlotText(titleText, plotText)
% Display the text on an individual plot
    title(titleText, 'FontSize', 9);
    lim = axis;
    text(lim(1) + 0.05 * (lim(2) - lim(1)), lim(4) - 0.025 * (lim(4) - lim(3)), plotText, 'FontSize', 9,...
        'VerticalAlignment', 'top');
end