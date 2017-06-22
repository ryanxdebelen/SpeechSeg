function segments = KL2_test(x, threshold1, threshold2)
    % KL2 (for testing the ACD)
    % Task: Compute KL2 coefficients of an audio signal
    % Author: Ryan Anthony J. de Belen
    % Date Last Modified: November 9, 2014
    % Instructions: The input to this function is the audio signal
    % The output of this script are the KL2 coefficients

    % Read the audio segment
    [d, sr] = audioread(x);
    
    % Initialize analysis window
    Wsize1 = 0.5;
    N1 = Wsize1*sr;
    Wsize2 = 1.0;
    N2 = Wsize2*sr;
    
    % Initialize the step size 
    stepsize = 0.010;
    Nstep = stepsize*sr;
    
    % Initialize variables
    h = 1;
    segments(h) = 0;
    h = h + 1;
    
    % OCTOBER 18, 2016
    ceptot = rastaplp(d, sr, 0, 12);

    for i=1:((length(d)-2*N2)/Nstep),
    
%         % Get the first window for analysis
%         FA1 = d( 1 + ((i-1)*Nstep) : N1 + ((i-1)*Nstep) );
%         FA2 = d( 1 + ((i-1)*Nstep) : N2 + ((i-1)*Nstep) );
%         
%         % Compute the PLP coefficients of the first window
%         [cepA1] = rastaplp(FA1, sr, 0, 12);
%         [cepA2] = rastaplp(FA2, sr, 0, 12);
%         
%         % Get the second window for analysis
%         FB1 = d( N1 + 1 + ((i-1)*Nstep) : 2*N1 + ((i-1)*Nstep) );
%         FB2 = d( N2 + 1 + ((i-1)*Nstep) : 2*N2 + ((i-1)*Nstep) );
%         
%         % Compute the PLP coefficients of the second window
%         [cepB1] = rastaplp(FB1, sr, 0, 12);
%         [cepB2] = rastaplp(FB2, sr, 0, 12);
        
        cepA1 = ceptot(:, i:48+i-1);
        cepA2 = ceptot(:, i:98+i-1);
        
        cepB1 = ceptot(:, 50+i:50+48+i-1);
        cepB2 = ceptot(:, 100+i:100+98+i-1);
        
        % Get the means and variances of the two windows
        muA1 = mean(cepA1, 2);
        sigmaA1 = var(cepA1, 0, 2);
        muB1 = mean(cepB1, 2);
        sigmaB1 = var(cepB1, 0, 2);
        
        muA2 = mean(cepA2, 2);
        sigmaA2 = var(cepA2, 0, 2);
        muB2 = mean(cepB2, 2);
        sigmaB2 = var(cepB2, 0, 2);
        
        % Transform the variances of the two windows into a full-diagonal
        % covariance matrices
        covmatA1 = diag(sigmaA1);
        covmatB1 = diag(sigmaB1);
        
        covmatA2 = diag(sigmaA2);
        covmatB2 = diag(sigmaB2);
    
        % Evaluate KL2
        kl21 = 1/2*trace( (covmatA1 - covmatB1).*(inv(covmatB1) - inv(covmatA1)) ) + 1/2*trace( (muA1 - muB1)*(muA1 - muB1)'*(inv(covmatA1) + inv(covmatB1)) );
        
        kl22 = 1/2*trace( (covmatA2 - covmatB2).*(inv(covmatB2) - inv(covmatA2)) ) + 1/2*trace( (muA2 - muB2)*(muA2 - muB2)'*(inv(covmatA2) + inv(covmatB2)) );
        
        % Employ the pre-determined threshold
        if kl21>threshold1,
            time = Wsize1 + i*stepsize;
            if (time - segments(h-1)) >= 1.5,
                segments(h) = time;
                h = h+1;
            end
        end
        if kl22>threshold2,
            time = Wsize2 + i*stepsize;
            if (time - segments(h-1)) >= 1.5,
                segments(h) = time;
                h = h+1;
            end
        end
    end
end
