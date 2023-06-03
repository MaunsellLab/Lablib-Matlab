classdef taskDict < handle
    % ctTaskData: common data for Contrasts Thresholds
    properties
        codes;
        letters;
        multipliers;
        names;
        taskNames;
    end
    
    methods
        %% taskDict
        function obj = taskDict()
            obj = obj@handle();                         	% instantiate object
            data = obj.codeData();                      	% get human readable data for dict
            obj.letters = [data{:, 2}];                   	% unpack data
            obj.multipliers = [data{:, 3}];
            obj.names = [data{:, 1}];
            for index = 1:length(obj.letters)               % make numerical codes from letters
                twoChar = obj.letters{index};
                obj.codes(index) = uint16(twoChar(1)) * 2^8 + uint16(twoChar(2)) + 2^15;
            end
            obj.taskNames = {'OPA', 'PRF', 'GRF', 'OP', 'OK', 'ID', 'SQ', 'MTC', 'TR', 'PO', 'MTN', 'OKP'...
                'IDP', 'VFM', 'MTO', 'IDN', 'TO', 'MTD'
            };
        end
    end
    
    %% Static class methods
    
    methods (Static)
         %% codeData -- convenience function to keep the codes in a readily readable form
         function data = codeData()
            data = [...
            {"attendLoc",          "AL", 1.0};...
            {"azimuth",            "AZ", 0.1};...
            {"break",              "BR", 1.0};...
            {"contrast",           "CO", 0.01};...
            {"contrast0",          "C0", 0.01};...
            {"contrast1",          "C1", 0.01};...
            {"catchTrial",         "CT", 1.0};...
            {"direction0",         "D0", 0.1};...
            {"direction1",         "D1", 0.1};...
            {"fixate",             "FI", 1.0};...
            {"fixOn",              "FO", 1.0};...
            {"eccentricity",       "EC", 0.1};...
            {"elevation",          "EL", 0.1};...
            {"instructTrial",      "IT", 1.0};...
            {"mapping0",           "M0", 1.0};...
            {"mapping1",           "M1", 1.0};...
            {"optoDelay",          "OD", 1.0};...
            {"stimulusOff",        "OF", 1.0};...
            {"stimulusOn",         "ON", 1.0};...
            {"orientation",        "OR", 0.1};...
            {"polarAngle",         "PA", 0.1};...
            {"powerBaseMW",        "P0", 0.1};...
            {"powerStimMW",        "P1", 0.1};...
            {"powerStimUW",        "P2", 1.0};...
            {"powerDurMS",         "PD", 1.0};...
            {"preStimDurMS",       "PS", 1.0};...
            {"quenchDelayMS",      "QW", 1.0};...
            {"quenchPowerMW",      "QP", 0.1};...
            {"quenchDurMS",        "QD", 1.0};...
            {"radius",             "RA", 0.1};...
            {"rampDone",           "RD", 1.0};...
            {"rampDurMS",          "RP", 1.0};...
            {"rfStimOff",          "RN", 1.0};...
            {"rfStimOn",           "RF", 1.0};...
            {"saccade",            "SA", 1.0};...
            {"settingsCode",       "SC", 1.0};...
            {"spatialFreq",        "SF", 0.01};...
            {"spatialFreq0",       "S0", 0.01};...
            {"spatialFreq1",       "S1", 0.01};...
            {"sigma",              "SI", 0.1};...
            {"stimType",           "ST", 1.0};...
            {"stimIndex",          "SX", 1.0};...
            {"targetOn",           "TO", 1.0};...
            {"taskCode",           "GR", 1.0};...
            {"taskGabor",          "TG", 1.0};...
            {"temporalFreq",       "TF", 0.01};...
            {"temporalFreq0",      "T0", 0.01};...
            {"temporalFreq1",      "T1", 0.01};...
            {"trialCertify",       "TC", 1.0};...
            {"trialEnd",           "TE", 1.0};...
            {"trialStart",         "TS", 1.0};...
            {"type0",              "X0", 1.0};...
            {"type1",              "X1", 1.0};...
            {"visualBasePC",       "VB", 1.0};...
            {"visualDurMS",        "VD", 1.0};...
            {"visualRampDurMS",    "VR", 1.0};...
            {"visualStimPC",       "VP", 1.0};...
            {"visualStimValue",    "VV", 0.01};...
        ];
        end  
    end
end

