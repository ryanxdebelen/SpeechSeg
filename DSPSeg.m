function DSPSeg(Input)
    tic
    x = ['Input/' Input]; 
    y = ['Segments/' x(7:11) '.txt']; 
    z = ['TextGrid/' x(7:11) '.TextGrid']; 
    TestACD_v2(x,y,z,65,18);
    toc
    SNS(x);
    BC(x);
    
    a = ['FinalOutputTextFile/' x(7:11) '.txt'];
    b = ['FinalOutputTextGrid/FinalOutput.TextGrid'];
    TextFiletoPraat(a,b);
%     cd Input
%     !Input.wav &
%     cd ..
%     cd FinalOutputTextGrid\
%     !FinalOutput.TextGrid
%     cd ..
end