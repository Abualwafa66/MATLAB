function latex = str2latex(str)

all_ind = find(str == 'e');
latex = str;

while ~isempty(all_ind)
    ind = all_ind(1);
    if latex(ind+1) == '+'; latex(ind+1) = ' '; end
    if latex(ind+2) == '0'; latex(ind+2) = ' '; end
    latex = [latex(1:ind-1) '\e{' latex(ind+1:ind+3) '}' latex(ind+4:end)];
    all_ind = all_ind + 3*ones(1,length(all_ind));
    all_ind(1) = [];
end