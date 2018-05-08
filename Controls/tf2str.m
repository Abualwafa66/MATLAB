function str = tf2str(sys)

if isa(sys,'double');
    str = num2str(sys);
elseif isa(sys,'tf');
    var = sys.var;
    [num, den] = tfcoef(sys);
    while num(1) == 0; num(1) = []; end;
    while den(1) == 0; den(1) = []; end;
    n = length(num);
    m = length(den);
    str = '$\frac{';
    
    %% numerator
    if n >= 2;
        % power > 1 term
        for i = 1:n-2;
            if num(i) ~= 1 && num(i);
                if i ~= 1;
                    str = [str, sprintf('%+.4g %s^%i ',num(i),var,n-i)];
                else
                    str = [str, sprintf('%.4g %s^%i ',num(i),var,n-i)];
                end
            elseif num(i) == 1;
                str = [str, sprintf('%s^%i ',var,n-i)];
            end
        end
        % power = 1 term
        if num(n-1) ~= 1 && num(n-1) && n ~= 2;
            str = [str, sprintf('%+.4g %s ',num(n-1),var)];
        elseif num(n-1) ~= 1 && num(n-1) && n == 2;
            str = [str, sprintf('%.4g %s ',num(n-1),var)];
        elseif num(n-1) == 1;
            str = [str, sprintf('%s ',var)];
        end
        % power = 0 term
        if num(n)
            str = [str, sprintf('%+.4g} {',num(n))];
        else
            str = [str '} {'];
        end
    elseif n == 1; % constant case
        str = [str, sprintf('%.4g} {',num(1))];
    end
    %% denominator
    if m >= 2;
        % power > 1 term
        for i = 1:m-2;
            if den(i) ~= 1 && den(i);
                if i ~= 1;
                    str = [str, sprintf('%+.4g %s^%i ',den(i),var,m-i)];
                else 
                    str = [str, sprintf('%.4g %s^%i ',den(i),var,m-i)];
                end
            elseif den(i) == 1;
                str = [str, sprintf('%s^%i ',var,m-i)];
            end
        end
        % power = 1 term
        if den(m-1) ~= 1 && den(m-1) && m ~= 2;
            str = [str, sprintf('%+.4g %s ',den(m-1),var)];
        elseif den(m-1) ~= 1 && den(m-1) && m == 2;
            str = [str, sprintf('%.4g %s ',den(m-1),var)];
        elseif den(m-1) == 1;
            str = [str, sprintf('%s ',var)];
        end
        % power = 0 term
        if den(m)
            str = [str, sprintf('%+.4g}$',den(m))];
        else
            str = [str '}$'];
        end
    elseif m == 1; % constant case
        str = [str, sprintf('%.4g}$',den(1))];
    end
    
end
end
