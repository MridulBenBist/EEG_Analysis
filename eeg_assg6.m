%% Preliminary EEG Analysis - MATLAB 2024b
% Run from: /Users/mridulbenbist/Documents/MATLAB/eeg

eeglab; close;

%% 1. Load participant info
partTable = readtable('participants.tsv', 'FileType', 'text', 'Delimiter', '\t');
fprintf('AD: %d | FTD: %d | Healthy: %d\n', ...
    sum(strcmp(partTable.Group, 'A')), ...
    sum(strcmp(partTable.Group, 'F')), ...
    sum(strcmp(partTable.Group, 'C')));

%% 2. Extract band power for ALL subjects
bandNames  = {'Delta', 'Theta', 'Alpha', 'Beta'};
bandRanges = [1 4; 4 8; 8 13; 13 30];

nSubs     = height(partTable);
bandPower = zeros(nSubs, 4);

fprintf('\nProcessing all %d subjects...\n', nSubs);
for s = 1:nSubs
    subID   = partTable.participant_id{s};
    setPath = ['derivatives/' subID '/eeg/'];
    setFile = [subID '_task-eyesclosed_eeg.set'];

    try
        EEGtmp  = pop_loadset('filename', setFile, 'filepath', setPath);
        meanSig = mean(double(EEGtmp.data), 1)';
        [pxx, f] = pwelch(meanSig, [], [], [], EEGtmp.srate);

        for b = 1:4
            idx = f >= bandRanges(b,1) & f <= bandRanges(b,2);
            bandPower(s, b) = mean(pxx(idx));
        end
        fprintf('  Done: %s (%s)\n', subID, partTable.Group{s});
    catch
        fprintf('  Skipped: %s\n', subID);
    end
end

%% 3. Compute group averages
groupOrder = {'A',  'C',  'F'  };
groupNames = {'AD', 'CN', 'FTD'};
colors     = [0.85 0.33 0.10;   % AD  - red/orange
              0.47 0.67 0.19;   % CN  - green
              0.30 0.57 0.82];  % FTD - blue

groupAvg = zeros(3, 4);
for g = 1:3
    mask = strcmp(partTable.Group, groupOrder{g});
    groupAvg(g, :) = mean(bandPower(mask, :), 1);
end

%% 4. Plot - one subplot per band
figure('Position', [100 100 1100 400]);
for b = 1:4
    subplot(1, 4, b);
    for g = 1:3
        bar(g, groupAvg(g, b), 'FaceColor', colors(g,:));
        hold on;
    end
    set(gca, 'XTick', 1:3, 'XTickLabel', groupNames, 'FontSize', 11);
    title(bandNames{b}, 'FontSize', 13, 'FontWeight', 'bold');
    ylabel('Power (\muV^2/Hz)');
    xlabel('Group');
    grid on;
    hold off;
end
sgtitle('EEG Band Power by Group (All Subjects Averaged)', 'FontSize', 14, 'FontWeight', 'bold');