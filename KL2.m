function kl2 = KL2(x)
    % KL2 (for training the ACD)
    % Task: Compute KL2 coefficients of an audio signal
    % Author: Ryan Anthony J. de Belen and Federson Joseph R. Francia
    % Date Last Modified: November 9, 2014
    % Instructions: The input to this function is the audio signal
    % The output of this script are the KL2 coefficients

    % Read the audio segment
    [d, sr] = audioread(x);
    
    % Initialize analysis window
    Wsize = 1.0;
    N = Wsize*sr;
    
    % Initialize the step size 
    stepsize = 0.010;
    Nstep = stepsize*sr;
    
    % Initialize variables
    cepAfit = makedist('normal');
    cepBfit = makedist('normal');
    muA = zeros(1,13);
    muB = zeros(1,13);
    sigmaA = zeros(1,13);
    sigmaB = zeros(1,13);
    
    % Truncate data with zeros
    d = [d', zeros(1,Nstep-mod(length(d)-2*N,Nstep))];
    kl2 = zeros(1,(length(d)-2*N)/Nstep);
    for i=1:((length(d)-2*N)/Nstep),
    
    % Get the first window for analysis
        FA = d( 1 + ((i-1)*Nstep) : N + ((i-1)*Nstep) );
        
    % Compute the PLP coefficients of the first window
        [cepA] = rastaplp(FA, sr, 0, 12);
        
    % Get the second window for analysis
        FB = d( N + 1 + ((i-1)*Nstep) : 2*N + ((i-1)*Nstep) );
        
    % Compute the PLP coefficients of the second window
        [cepB] = rastaplp(FB, sr, 0, 12);
        
    % Get the means and variances of the two windows
        muA = mean(cepA, 2);
        sigmaA = var(cepA, 0, 2);
        muB = mean(cepB, 2);
        sigmaB = var(cepB, 0, 2);
        
    % Transform the variances of the two windows into a full-diagonal
    % covariance matrices
        covmatA = diag(sigmaA);
        covmatB = diag(sigmaB);
        
    % Evaluate KL2
        kl2(i) = 1/2*trace( (covmatA - covmatB).*(inv(covmatB) - inv(covmatA)) ) + 1/2*trace( (muA - muB)*(muA - muB)'*(inv(covmatA) + inv(covmatB)) );
    
    end
end
