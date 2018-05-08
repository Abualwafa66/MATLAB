function dataforV(filename,data,coloffset)

dlmwrite(filename,data,'-append','roffset',0,'coffset',coloffset,'precision','%.8f');


