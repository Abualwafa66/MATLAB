function headerforV(filename,header)

if exist(filename,'file'); eval(['delete ' filename]); end
fid = fopen(filename,'w+'); fclose(fid);

fid = fopen(filename,'r+'); 
fprintf(fid,'%s\n',header); 
fclose(fid);