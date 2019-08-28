function pKernel

    numBins = 100;                                      % number of bins
    stimNoise = 0.5;                                    % noise in the stimulus signal
    optoPower = -0.075;
    % make the kernel to find
    
    kernel = zeros(1, numBins);
    midPoint = numBins / 2;
    kernel(midPoint - 5:midPoint - 1) = -0.5;
    kernel(midPoint:midPoint + 9) = 1.0;
    kernel(midPoint + 9:midPoint + 19) = 0.2;
    
    doPsycho(kernel, stimNoise, optoPower);
%     doDistributions(kernel, stimNoise);               % effect of stim noise distributions (uniform, binary, Gaussian)
%     doVariance(kernel, noiseFactor);                    % effect of stim noise variance
end
