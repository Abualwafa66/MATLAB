function [r] = multiroot(f,range,n)

x = linspace(range(1),range(2),n);
dx = (range(2)-range(1))/(n-1);
y = f(x);
% plot(x,y); grid on;
% xlim(range); ylim([-1 1]);

jj = 1; kk = 1;
for i = 1:n-1;
    if y(i) == 0;
        root(kk) = x(i);
        kk = kk + 1;
    elseif sign(y(i)*y(i+1)) == -1;
        rootrange(jj) = x(i);
        jj = jj + 1;
    end
end

for j = 1:jj-1;
    a = rootrange(j); b = rootrange(j) + dx;
    f1 = f(a);
    for i = 1:50;
        c = (a+b)/2; f3 = f(c);
        s = sign(f1*f3);
        switch s
            case 1
                a = c; f1 = f3;
            case -1
                b = c;
            case 0
                break;
        end
    end
    root(kk) = (a+b)/2; kk = kk+1;
end

root  = sort(root);
check = abs(f(root)) <= 1e-10;
root(find(check == 0)) =[];
r = root;
