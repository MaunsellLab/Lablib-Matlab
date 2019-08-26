%%
function setUpFigure(figureNum, kernel, titleText, headerText)
% Prepare a page of plots by displaying the header and plotting the profile of the kernel to find.

    f = figure(figureNum);
    f.Units = 'inches';
    f.Position = [20, 5, 8.5, 11];
    clf;
    h = subplot(4, 3, 1);
    set(h, 'Visible', 'off');
    set(h, 'OuterPosition', [0.02 0.75, 0.25, 0.2]);
    text(0.00, 1.25, titleText, 'FontWeight', 'bold', 'FontSize', 14);
    if nargin > 3
        text(0.00, 1.00, headerText, 'FontWeight', 'bold', 'FontSize', 12);
    end
    subplot(4, 3, 3, 'replace');
    plot(kernel);
    title('Actual Kernel', 'FontSize', 9);
    drawnow;
end
