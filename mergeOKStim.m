function mergeOKStim(eventFile, OKFile, directory)

% mergeOKStim
% Merges optical white noise stimulus data from a .mat file from OKernel with a .mat file produced
% from a NEV file (using extractNEV).  It would be impractical to encode all the white noise stimulus
% data into bytes sent to the Blackrock Cerebus during recording, so we take them from the OKernel
% Matlab file and merge them after recording. 

    % for testing
    if nargin < 3
        directory = '~/Desktop/';
        if nargin < 2
            eventFile = input('Matlab file from extractNEV: ', 's');
            if nargin < 1
                OKFile = input('Matlab file from OKernel: ', 's');
            end
        end
    end
%     NEV = readNEV(strcat(nevFile, '.nev'));  % read .nev file
    E = load([directory eventFile]);
    O = load([directory OKFile]);
    tIndex = find(strcmp([E.taskNames{:}], 'OK'));
    assert(length(tIndex) == 1, 'There must be one and only one OK task in the NEV file');
    
    OKTrials = {O.trials(:).trial};
    numOKTrials = length(OKTrials);
    OKCodes = zeros(1, numOKTrials);
    for t = 1:numOKTrials
        OKCodes(t) = OKTrials{t}.serialNumber;
    end
    numETrials = length(E.taskEvents{tIndex});
    for t = 1:numETrials
        trialCode = E.taskEvents{tIndex}(t).trialStart.data;
        OKIndex = find(OKCodes == trialCode);
        assert(length(OKIndex) == 1, 'There must be one and only one OK matching serial number');
        E.taskEvents{tIndex}(t).zeroOptoFromPhotoDiode = O.trials(OKIndex).zeroOptoFromPhotoDiode;
        E.taskEvents{tIndex}(t).optoStepTimesMS = O.trials(OKIndex).optoStepTimesMS;
        E.taskEvents{tIndex}(t).optoStepPowerMW = O.trials(OKIndex).optoStepPowerMW;
    end
    
% % Saving the merged file

clear endCode endTime event eventIndex eventName index startCode startTime t taskEnds taskStart

if contains(eventFile, 'NEV')
    eventFile = replace(eventFile, 'NEV', 'MRG');
else
    eventFile = [eventFile, 'MRG'];
end
save([directory eventFile], '-struct', 'E', 'taskNames', 'taskEvents', 'taskSpikes', 'nevFile');
fprintf('Merged data for %d trials. Saved to %s\n', numETrials, [directory eventFile]); 
end 