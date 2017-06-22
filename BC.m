function BC(x)

sr = 16000;
winpts = 400;
steppts = 160;
load('netBC.mat')

y = ['SNSTextFile/' x(7:11) '.txt'];
z = ['FinalOutputTextFile/' x(7:11) '.txt'];
[d, sr] = audioread(x);
[cep] = rastaplp(d, sr, 0, 12);

context = 5;

newcepBC = zeros(13*context, length(cep(1,:)));

for i=1:context,
    newcepBC(1+(i-1)*13:13*i,1:end-i+1) = [cep(:,i:end)];
end

finalcepBC(:,1:size(newcepBC,2)-(context-1)) = newcepBC(:,1:size(newcepBC,2)-(context-1));

Y = sim(netBC5Context, finalcepBC);
S = tdfread(y);
tags = zeros(1,size(S.Tags,1));

initind = 1;
finalind = 0;

for h = 2:size(S.Start_Time,1),
    ind = floor((sr*(S.Start_Time(h)-S.Start_Time(h-1)) - winpts)/steppts + 1);
    finalind = finalind + ind + 1;
    if sum(Y(1,initind:finalind)) >= sum(Y(2,initind:finalind)),
        if sum(Y(1,initind:finalind)) >= sum(Y(3,initind:finalind)),
            tags(h-1) = 1;
        else
            tags(h-1) = 3;
        end
    elseif sum(Y(2, initind:finalind)) >= sum(Y(3, initind:finalind)),
        tags(h-1) = 2;
    else
        tags(h-1) = 3;
    end
    initind = finalind + 1;
end

initind = finalind + 1;
ind = floor((sr*(S.End_Time(h)-S.Start_Time(h)) - winpts)/steppts + 1);
finalind = finalind + ind;

if sum(Y(1,initind:finalind)) >= sum(Y(2,initind:finalind)),
    if sum(Y(1,initind:finalind)) >= sum(Y(3,initind:finalind)),
        tags(h) = 1;
    else
        tags(h) = 3;
    end
elseif sum(Y(2, initind:finalind)) >= sum(Y(3, initind:finalind)),
    tags(h) = 2;
else
    tags(h) = 3;
end

fid = fopen(z, 'wt+');
fprintf(fid, 'Start Time\tEnd Time\tTags\n');
if tags(1) == 1,
    BCTag = 'CLEAN';
elseif tags(1) == 2,
    BCTag = 'NOISY';
elseif tags(1) == 3,
    BCTag = 'MUSIC';
end
tag = ['"' S.Tags(1,2:12) '_' BCTag '"'];
S.Tags(1,1:size(tag,2)) = tag;
fprintf(fid, '%f\t%f\t%s\n',S.Start_Time(1),S.End_Time(1),S.Tags(1,1:size(tag,2)));

for i = 2:size(S.Tags,1),
    if tags(i) == 1,
        BCTag = 'CLEAN';
    elseif tags(i) == 2,
        BCTag = 'NOISY';
    elseif tags(i) == 3,
        BCTag = 'MUSIC';
    end
    tag = ['"' S.Tags(i,2:12) '_' BCTag '"'];
    S.Tags(i,1:size(tag,2)) = tag;
    fprintf(fid, '%f\t%f\t%s\n',S.Start_Time(i),S.End_Time(i),S.Tags(i,1:size(tag,2)));
end
fclose(fid);

end