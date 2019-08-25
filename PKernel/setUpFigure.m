%%
function setUpFigure(figureNum, kernel, headerText)
% Prepare a page of plots by displaying the header and plotting the profile of the kernel to find.

    f = figure(figureNum);
    f.Units = 'inches';
    f.Position = [20, 5, 8.5, 11];
    clf;
    h = subplot(4, 3, 1);
    set(h, 'Visible', 'off');
    set(h, 'OuterPosition', [0.02 0.75, 0.25, 0.2]);
    text(0.00, 1.25, headerText, 'FontWeight', 'bold', 'FontSize', 16);
    subplot(4, 3, 3, 'replace');
    plot(kernel);
    title('Actual Kernel');
    drawnow;
end
