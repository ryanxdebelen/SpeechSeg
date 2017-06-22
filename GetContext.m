function finalcep = GetContext(cep, context),
    % Task: Employ the context input frame in the cepstal coefficients
    % Author: Ryan Anthony J. de Belen
    % Date Last Modified: March 6, 2015
    % Instructions: The input to this script are the cepstral coefficients
    % and the context to be included
    % The script outputs the cepstral coefficients with context
    
    % Initialize the variable
    newcep = zeros(13*context, length(cep(1,:)));

    % Construct the input context frame
    for i=1:context,
       newcep(1+(i-1)*13:13*i,1:end-i+1) = [cep(:,i:end)];
    end

    % Construct the final context frame
    finalcep(:,:) = newcep(:,1:length(newcep(1,:))-(context-1));
    
end