function latextablec(mat,info,r,c)
% latextablec(mat,info,r,c) creates a latex table for a
% given matrix with data based on columns
%
% info is a matrix with same width of mat and 3 rows, info = [e; d; sn], where:
% e  is a row vector of 1 and 0; 1 indicates this column is the error for the previous column
% d  is a row vector with the number of digits for each column
% sn is a row vector of 1 and 0; 1 indicates the use of scientific notation for this column
%
% r  is 1 or 0 indicating whether to add a additional row to the top
% c  is 1 or 0 indicating whether to add a additional column to the left

e  = info(1,:);
d  = info(2,:);
sn = info(3,:);

printnormal = @(num,digits) fprintf(' % *.*g ', digits+2, digits, num);
printerror = @(num,error,digits) fprintf('$ % *.*g \\pm %*.*g $', digits+2, digits, num, digits+2, digits, error);
printsn = @(num,digits) fprintf('$ %*.*g \\e{%d} $',digits+2, digits, num*10^(-floor(log10(num))),floor(log10(num)));
printsnerror = @(num,error,digits) fprintf('$ (%*.*g \\pm %*.*g) \\e{%d} $' ...
    , digits+2, digits, num*10^(-floor(log10(num))),digits+2, digits, error*10^(-floor(log10(num))),floor(log10(num)));
%% Print Header
[m,n] = size(mat);
size_n = n - sum(e);
fprintf('\n\\begin{table}[H] \n\\caption{      } \n\\centering \n\\renewcommand{\\arraystretch}{1.5} \n\\begin{tabular}{|');

for i = 1:size_n-1; fprintf('c|');end
if c; fprintf('c|');end
fprintf('c|}  \\hline\n\n');
if r;
    if c; fprintf('      & ');end;
    for i = 1:size_n-1; fprintf('           & '); end;
    fprintf('      \\\\    \\hline \n');
end

%% Print Data
for i = 1:m;
    if c; fprintf('      & ');end
    for j = 1:n-1;
        if e(j)==0 && e(j+1)==0 && sn(j)==0;
            printnormal(mat(i,j),d(j));
            fprintf(' & ');
        elseif e(j)==0 && e(j+1)==1 && sn(j)==0;
            printerror(mat(i,j),mat(i,j+1),d(j)); fprintf(' & ');
        elseif e(j)==0 && e(j+1)==0 && sn(j)==1;
            printsn(mat(i,j),d(j));  fprintf(' & ');
        elseif e(j)==0 && e(j+1)==1 && sn(j)==1;
            printsnerror(mat(i,j),mat(i,j+1),d(j));  fprintf(' & ');
        end
    end
    if e(n)==0 &&  sn(n)==0;
        printnormal(mat(i,n),d(n));
    elseif e(n)==0 && sn(n)==1;
        printsn(mat(i,n),d(n));
    elseif e(n)==1;
        fprintf('\b\b');
    end
    fprintf(' \\\\    \\hline \n');
end

%% Print Ending
fprintf('\\end{tabular} \n\\label{  } \n\\end{table}\n\n\n\n');
