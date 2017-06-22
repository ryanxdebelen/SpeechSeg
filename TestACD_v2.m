function TestACD_v2(x, y, z, threshold1, threshold2)
    % TestACD_v2
    % Task: Compute segments given the pre-determined threshold
    % Author: Ryan Anthony J. de Belen and Federson Joseph R. Francia
    % Date Last Modified: January 17, 2015
    % Instructions: The input to this function is the audio file, the
    % pre-determined threshold and the window size
    % The output of this script are the segments

    segments = KL2_test(x, threshold1, threshold2);
    ACDtoTextFile(segments, y);
    TextFiletoPraat(y, z);

end