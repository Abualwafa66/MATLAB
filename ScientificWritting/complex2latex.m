function str = complex2latex(complex,varargin)

if isempty(varargin)
    digits = 4;
else digits = varargin{1};
end

r = real(complex);
i = imag(complex);

str = [];

for ii = 1:length(r);
    if ii >= 2; str = [str ', \quad']; end
    if i(ii) == 0;
        str = [str sprintf('%.*f',digits,r(ii))];
    else str = [str sprintf('%.*f%+.*fi',digits,r(ii),digits,i(ii))];
    end
end

end