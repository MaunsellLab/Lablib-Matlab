function pKernel

    numBins = 100;                                      % number of bins
    noiseFactor = 1.0;                                  % noise magnitude relative to signal perturbation
    
    % make the kernel to find
    
    kernel = zeros(1, numBins);
    kernel(20) = 0.5;
    kernel(80) = -0.5;
    midPoint = numBins / 2;
    kernel(midPoint - 10:midPoint - 1) = -1.0:0.1:-0.1;
    kernel(midPoint:midPoint + 9) = 1;
    
    doDistributions(kernel, noiseFactor);               % effect of stim noise distributions (uniform, binary, Gaussian)
    doVariance(kernel, noiseFactor);                    % effect of stim noise variance
end
