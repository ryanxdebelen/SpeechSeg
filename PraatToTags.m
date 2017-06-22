function PraatToTags(x,y)
    % Task: Get the tags of the audio segment from the Praat Grid text file
    % Author: Ryan Anthony J. de Belen
    % Date Last Modified: January 28, 2015
    % Instructions: The input to this function is the Praat Grid text file
    % The script outputs a text file containing three columns
    % Start Time, End Time, and Tags

    firstcolumn= 'xmin';
    secondcolumn = 'xmax';
    thirdcolumn = 'text';

    fid = fopen(x);
    f = fscanf(fid,'%c');
    [m n] = size(f);

    inc = 0;
    wrdinc = 1;
    a = 1;
    b = 1;
    c = 1;

    for chr =1:n,
        inc = inc + 1;
        if f(inc) == ' ';
            wordc{wrdinc}=f(1:inc-1);
            f(1:inc)=[];
            wrdinc=wrdinc+1;
            inc=0;
        end
    end

    [m n]=size(wordc);

    for i = 1:n,
        m= char(wordc{i});
        if strcmp(wordc{i}, firstcolumn) == 1,
            starttime(a) = str2num(wordc{i+2});
            a = a + 1;
        end
        if strcmp(wordc{i}, secondcolumn) == 1,
            endtime(b) = str2num(wordc{i+2});
            b = b + 1;
        end    
        if strcmp(wordc{i}, thirdcolumn) == 1,
            tags{c} = wordc{i+2};
            c = c + 1;
        end
    end

    starttime = starttime(2:end);
    endtime = endtime(2:end);

    fclose(fid);

    newfid = fopen(y, 'wt+');
    title = 'Start Time\tEnd Time\tTags\n';
    fprintf(newfid, title);

    for i = 1:length(starttime),
        fprintf(newfid, sprintf('%d\t%d\t%s\n', starttime(i), endtime(i), strcat(char(tags{:,i}))));
    end

    fclose(newfid);

end 