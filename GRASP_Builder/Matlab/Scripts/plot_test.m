%% sinus_plot.m
% Reads frequency from a config file and plots a sinusoid

% --- Step 1: Read config file ---
configFile = 'config.txt';
configData = readlines(configFile);

% Initialize default values
frequency = 1;     % Hz
amplitude = 1;
duration = 1;      % seconds
sampling_rate = 1000; % Hz

% Parse each line
for i = 1:length(configData)
    line = strtrim(configData(i));
    if startsWith(line, 'frequency')
        frequency = str2double(extractAfter(line, '='));
    elseif startsWith(line, 'amplitude')
        amplitude = str2double(extractAfter(line, '='));
    elseif startsWith(line, 'duration')
        duration = str2double(extractAfter(line, '='));
    elseif startsWith(line, 'sampling_rate')
        sampling_rate = str2double(extractAfter(line, '='));
    end
end

% --- Step 2: Generate signal ---
t = 0:1/sampling_rate:duration;
y = amplitude * sin(2*pi*frequency*t);

% --- Step 3: Plot ---
figure;
plot(t, y, 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title(sprintf('Sine wave: %.2f Hz', frequency));
waitfor(gcf); 
% --- Step 4: Print confirmation ---
fprintf('Plot generated with frequency = %.2f Hz, amplitude = %.2f\n', frequency, amplitude);
