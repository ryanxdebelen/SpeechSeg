function ACDtoTextFile(segments, y)
    % ACDtoTextFile
    % Task: Prepare a text file from segments
    % Author: Ryan Anthony J. de Belen
    % Date Last Modified: October 8, 2014
    % Instructions: The input to this function is the segments text file
    % The script outputs a Praat Text Grid File

    % Create a text file
    fid = fopen(y, 'wt+');

    fprintf(fid, 'Start Time\tEnd Time\tTags');

    for i=1:length(segments)-1,
        fprintf(fid, '\n%d\t%d\t"TAGS"', segments(i), segments(i+1));
    end

    fclose(fid);
    
end