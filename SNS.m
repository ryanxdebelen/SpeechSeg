function SNS(x)
% Task: Run the SNS block for Speech/Non-Speech classification
% Author: Ryan Anthony J. de Belen
% Date Last Modified: March 6, 2015
% Instructions: There is no input to this script. Note that the input
% file/s to be processed should be in the Input folder contained in the
% SNS folder.
% The script outputs text files containing SNS tags. These are
% located in the Output folder contained in the SNS folder.

% Initialize variables
sr = 16000;     % Sampling rate
winpts = 400;   % Window length in number of points
steppts = 160;  % Step size in number of points

% Get the filenames of the input and the ground truth text files
% The Input folder contains the .wav files to be classified
% The TextFile folder contains the ground truth segment boundaries
% The TextFile folder can also contain the output of the ACD if the
% whole media monitoring system will be implemented

% Load the SNS network

%#function network
load('netSNS5Context.mat')

% Initialize the variable names for the files to be accessed

y = ['Segments/' x(7:11) '.txt'];
% The Output folder is an empty folder where the output of the SNS
% block can be found after system run
z = ['SNSTextFile/' x(7:11) '.txt'];

% Read the .wav file
[d, sr] = audioread(x);
% Compute the cepstral coefficients
[cep] = rastaplp(d, sr, 0, 12);

% Initial the number of context
context = 5;

% Get the cepstral coefficients with context
finalcep = GetContext(cep, context);

% Compute for the posterior probabilities from the SNS network
Y = sim(netSNS5Context, finalcep);

% Read the ground truth
S = tdfread(y);

% Initialize the final tags
tags = zeros(1,length(S.Tags));

% Initialize the index number
initind = 1;
finalind = 0;
for h = 2:size(S.Start_Time,1),
    % Compute for the index number where the segment boundary
    % can be found
    ind = floor((sr*(S.Start_Time(h)-S.Start_Time(h-1)) - winpts)/steppts + 1);
    
    % Final index determines the end of the segment
    finalind = finalind + ind + 1;
    
    % Compare the two posterior probability outputs of the system
    % Get the sum and determine which is greater
    % If the first class is greater than the second class, the
    % final tags for that segment should be 1
    if sum(Y(1,initind:finalind)) >= sum(Y(2,initind:finalind)),
        tags(h-1) = 1;
    else
        % If the second class is greater than the first class, the
        % final tags for that segment should be 2
        tags(h-1) = 2;
    end
    % The initial index would be the final index of the previous
    % segment plus 1.
    initind = finalind + 1;
end

% The initial index would be the final index of the previous
% segment plus 1.
initind = finalind + 1;

% Compute for the index number where the segment boundary
% can be found
ind = floor((sr*(S.End_Time(h)-S.Start_Time(h)) - winpts)/steppts + 1);


% Final index determines the end of the segment
finalind = finalind + ind;

% Compare the two posterior probability outputs of the system
% Get the sum and determine which is greater
% If the first class is greater than the second class, the
% final tags for that segment should be 1
if sum(Y(1,initind:finalind)) >= sum(Y(2,initind:finalind)),
    tags(h) = 1;
else
    % If the second class is greater than the first class, the
    % final tags for that segment should be 2
    tags(h) = 2;
end

% Create the SNS output text file
fid = fopen(z, 'wt+');
% Indicate in the SNS output text file the Start Time, End Time and
% Tags indicator
fprintf(fid, 'Start Time\tEnd Time\tTags\n');

% Complete the SNS Tags: "TAGS_X" ; 1 if speech; 2 if non-speech
if tags(1) == 1,
    SNSTag = 'SPEECH';
elseif tags(1) == 2,
    SNSTag = 'NON-SP';
end

S.Tags(1,1:13) = ['"' S.Tags(1,2:5) '_' SNSTag '"'];

% Indicate in the SNS output text file the start time, end time, and
% SNS output tags
fprintf(fid, '%f\t%f\t%s\n',S.Start_Time(1),S.End_Time(1),S.Tags(1,:));

for i = 2:size(S.Tags,1),
    if tags(i) == 1,
        SNSTag = 'SPEECH';
    elseif tags(i) == 2,
        SNSTag = 'NON-SP';
    end
    % Complete the SNS Tags: "TAGS_X" ; 1 if speech; 2 if non-speech
    
    S.Tags(i,1:13) = ['"' S.Tags(i,2:5) '_' SNSTag '"'];
    % Indicate in the SNS output text file the start time, end time, and
    % SNS output tags
    fprintf(fid, '%f\t%f\t%s\n',S.Start_Time(i),S.End_Time(i),S.Tags(i,:));
end

% Close the SNS output text file
fclose(fid);

end