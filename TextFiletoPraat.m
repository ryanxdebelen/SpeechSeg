function TextFiletoPraat(x, z)
    % TextFiletoPraat
    % Task: Prepare a Praat Text Grid from the text file
    % Author: Ryan Anthony J. de Belen
    % Date Last Modified: October 8, 2014
    % Instructions: The input to this function is the segments text file
    % The script outputs a Praat Text Grid File

    S = tdfread(x);

    fid = fopen(z, 'wt+');

    header1 = 'File type = "ooTextFile"\n';
    header2 = 'Object class = "TextGrid"\n\n';
    header3 = 'xmin = 0\n';
    xmax = max(S.End_Time);
    header4 = sprintf('xmax = %d\n', xmax);
    header5 = 'tiers? <exists>\n';
    header6 = 'size = 1\n';
    header7 = 'item []:\n';
    header8 = '\titem [1]:\n';
    header9 = '\t\tclass = "IntervalTier"\n';
    header10 = '\t\tname = "Annotation"\n';
    header11 = '\t\txmin = 0\n';
    header12 = sprintf('\t\txmax = %d\n', xmax);
    length = size(S.Start_Time,1);
    header13 = sprintf('\t\tintervals: size = %d\n', length);

    fprintf(fid, header1);
    fprintf(fid, header2);
    fprintf(fid, header3);
    fprintf(fid, header4);
    fprintf(fid, header5);
    fprintf(fid, header6);
    fprintf(fid, header7);
    fprintf(fid, header8);
    fprintf(fid, header9);
    fprintf(fid, header10);
    fprintf(fid, header11);
    fprintf(fid, header12);
    fprintf(fid, header13);

    for i = 1:length,
        fprintf(fid, sprintf('\t\tintervals [%d]:\n', i));
        fprintf(fid, sprintf('\t\t\txmin = %d\n', S.Start_Time(i)));
        fprintf(fid, sprintf('\t\t\txmax = %d\n', S.End_Time(i)));
        fprintf(fid, sprintf('\t\t\ttext = %s\n', S.Tags(i,:)));
    end

    fclose(fid);

end