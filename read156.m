function [t, T1, T2, T3, T4, T5, P1, P2, duty, starttime] = read156(filename);

data = csvread(filename,0,1);

t = data(:,1)./1000./60;
t = t-t(1);
T1 = R2T(data(:,2));
T2 = R2T(data(:,3));
T3 = R2T(data(:,4));
T4 = R2T(data(:,5));
T5 = R2T(data(:,6));
P1 = data(:,7);
P2 = data(:,8);
duty = data(:,9);

fid = fopen(filename);
data = textscan(fid, '%s');
fclose(fid);
data = data{1};

for i = 1:length(data);
    if strcmp(data{i},'Running'); ind = i; break; end
end
starttime = t(ind);


end