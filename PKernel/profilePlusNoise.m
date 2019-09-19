function [noisyStim, optoStim] = profilePlusNoise(stimProfile, stimNoise, optoSD, distName)
        
    optoStim = getRandom(0.0, 1.0, distName, length(stimProfile)) * optoSD;
    noisyStim = stimProfile * exp((rand - 0.5) * stimNoise) + optoStim;
end
