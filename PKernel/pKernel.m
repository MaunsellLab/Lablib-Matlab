function pKernel

    numBins = 50;                                       % number of bins
    stimNoise = 0.5;                                    % noise in the visual/inherent signal
    optoNoise = 0.025;                                  % scaling factor for opto noise intensity

    % make the kernel to find
    kernel = zeros(1, numBins);
    midPoint = numBins / 2;
    kernel(midPoint - 5:midPoint - 1) = -0.5;
    kernel(midPoint:midPoint + 9) = 1.0;
    kernel(midPoint + 9:midPoint + 19) = 0.2;
    % set up the visual stimulus
    stimProfile = zeros(1, numBins);
    midPoint = numBins / 2;
    stimProfile(midPoint:midPoint + 20) = 0.5;
    
%     doVariance(kernel, stimProfile, stimNoise);                    % effect of opto noise variance
%     doRho(kernel, stimProfile, stimNoise);
%     doNoise(kernel, stimNoise);
	doPsycho(kernel, stimNoise, optoNoise)
%     doDistributions(kernel, stimProfile, stimNoise);               % effect of stim noise distributions (uniform, binary, Gaussian)
end
