function optoStim = getRandom(distMean, distSD, distName, bins)

    switch distName                                      % make distributions from 0:2
        case 'Uniform'
            optoStim = rand(1, bins) * distSD / 0.2887 + (distMean - distSD / 0.2887 / 2.0);
        case 'Binary'
            optoStim = randi([0 1], [1, bins]) * distSD / 0.5 + (distMean - distSD);
        case 'Gaussian'
            optoStim = randn(1, bins) * distSD + distMean;
        otherwise
            error('Unrecognized column value');
    end
end
