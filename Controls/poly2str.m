function str = poly2str(poly)

var = 's';
while poly(1) == 0; poly(1) = []; end;
n = length(poly);
str = '$';

if n >= 2;
    % power > 1 term
    for i = 1:n-2;
        if poly(i) ~= 1 && poly(i);
            if i ~= 1;
                str = [str, sprintf('%+.4g %s^%i ',poly(i),var,n-i)];
            else
                str = [str, sprintf('%.4g %s^%i ',poly(i),var,n-i)];
            end
        elseif poly(i) == 1;
            str = [str, sprintf('%s^%i ',var,n-i)];
        end
    end
    % power = 1 term
    if poly(n-1) ~= 1 && poly(n-1);
        str = [str, sprintf('%+.4g %s ',poly(n-1),var)];
    elseif poly(n-1) == 1;
        str = [str, sprintf('%s ',var)];
    end
    % power = 0 term
    if poly(n)
        str = [str, sprintf('%+.4g$',poly(n))];
    else
        str = [str '$'];
    end
elseif n == 1; % constant case
    str = [str, sprintf('%.4g$',poly(1))];
end