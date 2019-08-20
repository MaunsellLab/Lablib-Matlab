function pKernel

    bins = 100;
    kernel = zeros(1, bins);
    kernel(20) = 0.5;
    midPoint = bins / 2;
    kernel(midPoint - 10:midPoint - 1) = -1.0:0.1:-0.1;
    kernel(midPoint:midPoint + 9) = 1;

    figure(1);
    clf;
    subplot(4, 3, 1, 'replace');
    plot(kernel);
    title('Kernel');
    
    doTrials(1, kernel);
    doTrials(2, kernel);
    doTrials(3, kernel);
end

function doTrials(col, kernel)

    bins = length(kernel);
    posKernel = zeros(1, bins);
    negKernel = zeros(1, bins);
    numPos = 0;
    numNeg = 0;
    reps = 1000;
    plotRep = reps / 4;
    for r = 1:reps
        switch col
            case 1
                stim = rand(1, bins);
            case 2
                stim = randi([0 1], [1, bins]);
            case 3
                stim = randn(1, bins) / 2 + 0.5;
            otherwise
                error('Unrecognized column value');
        end
        product = kernel .* stim;
        prob = sum(product);  
        if prob > 0.5
            posKernel = posKernel + stim;
            numPos = numPos + 1;
        else
            negKernel = negKernel + stim;
            numNeg = numNeg + 1;
        end
        if mod(r, plotRep) == 0
            doPlots(col, posKernel, numPos, negKernel, numNeg, r, kernel);
        end
    end
    doPlots(col, posKernel, numPos, negKernel, numNeg, r, kernel);

end

%%
function doPlots(col, posKernel, numPos, negKernel, numNeg, reps, kernel)

    switch col
        case 1
            theTitle = 'Uniform';
        case 2
            theTitle = 'Binary';
        case 3
            theTitle = 'Gaussian';
    end
    subplot(4, 3, 4 + col - 1, 'replace');
    plot(posKernel / numPos - negKernel / numNeg);
    title(sprintf('%s Kernel (n=%d)', theTitle, reps));
    rho = corrcoef(kernel, posKernel / numPos - negKernel / numNeg);
    displayText(sprintf('r = %.4f', rho(1, 2)));

    subplot(4, 3, 7 + col - 1, 'replace');
    plot(posKernel / numPos);
    title(sprintf('%s Positive Kernel (n=%d)', theTitle, numPos));    
    rho = corrcoef(kernel, posKernel);
    displayText(sprintf('r = %.4f', rho(1, 2)));
    
    subplot(4, 3, 10 + col - 1, 'replace');
    plot(negKernel / numNeg);
    title(sprintf('%s Negative Kernel (n=%d)', theTitle, numNeg));    
    rho = corrcoef(kernel, negKernel);
    displayText(sprintf('r = %.4f', rho(1, 2)));
    drawnow;
end

%%
function displayText(theText)

    lim = axis;
    text(lim(1) + 0.05 * (lim(2) - lim(1)), lim(4) - 0.05 * (lim(4) - lim(3)), theText);
end