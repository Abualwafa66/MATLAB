function latextable(matrix,d,r,c)
% latextable(matrix,d,r,c) creates a latex table for a given matrix
% d is the number of digits
% r is 1 or 0 indicating whether to add a additional row to the top
% c is 1 or 0 indicating whether to add a additional column to the left
clc;

%% Print Beginning
digits(d); 
[m,n] = size(matrix);
fprintf('\n\\begin{table}[H] \n\\caption{      } \n\\centering \n\\begin{tabular}{|');

for i = 1:n-1; fprintf('c|');end
if c; fprintf('c|');end
fprintf('c|}  \\toprule\n\n\n');
if r; 
    if c; fprintf('      & ');end; 
    for i = 1:n-1; fprintf('      & '); end;
    fprintf('      \\\\    \\midrule \n');
end

%% Print Data
for i = 1:m;
    temp = latex(vpa(sym(matrix(i,:))));
    index = find(temp == '}',2);
    index = index(2);
    temp = temp([index+1:end-18]);
    temp = [' ' temp ' '];
    index_and = find(temp == '&');
    index_slash = find(temp == '\');
    index1 = zeros(1,length(index_slash));
    index2 = zeros(1,length(index_slash));
    for j = 1:length(index_slash);
        index_temp = sort([index_and index_slash(j)]);
        index_temp = [1 index_temp length(temp)];
        index = find(index_temp == index_slash(j));
        index1(j) = index_temp(index-1);
        index2(j) = index_temp(index+1);
    end
    temp(1,[index1+1,index2-1]) = '$';
    
    while ~isempty(findstr(temp,'\cdot'));
        index = findstr(temp,'\cdot');
        index = index(1);
        temp = [temp(1:index-1) ' \times ' temp(index+5:end)];
    end
    
    
    if c; fprintf('      & ');end
    fprintf('%s',temp);
    fprintf(' \\\\       \\midrule \n');
end

%% Print Ending
fprintf('\b\b\b\b\b\b\b\b\bbottomrule \n\n\n\\end{tabular} \n\\label{  } \n\\end{table}\n\n\n\n');
