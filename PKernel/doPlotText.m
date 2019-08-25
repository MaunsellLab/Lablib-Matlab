function doPlotText(titleText, plotText)
% Display the text on an individual plot
    title(titleText);
    lim = axis;
    text(lim(1) + 0.05 * (lim(2) - lim(1)), lim(4) - 0.025 * (lim(4) - lim(3)), plotText, 'VerticalAlignment', 'top');
end