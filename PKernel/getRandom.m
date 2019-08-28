function stim = getRandom(distMean, distSD, distName, bins)

    switch distName                                      % make distributions from 0:2
        case 'Uniform'
            stim = rand(1, bins) * distSD / 0.2887 + (distMean - distSD / 0.2887 / 2.0);
        case 'Binary'
            stim = randi([0 1], [1, bins]) * distSD / 0.5 + (distMean - distSD);
        case 'Gaussian'
            stim = randn(1, bins) * distSD + distMean;
        otherwise
            error('Unrecognized column value');
    end
end
