clear all; close all; clc; format short
%
%
m = [4 0; 0 2];
k = [6 -2; -2 5];
n = 2;
x0 = [0; 0];
dx0 = [1; 0];
% m = [10 0 0; 0 10 0; 0 0 10];
% k = 100*[2 -1 0; -1 2 -1; 0 -1 1];
% n = 3;
% x0 = [0.1; 0.1; 0];
% dx0 = [0; 0; 0];
%
%
syms w2
w2 = solve(det(k-w2*m)==0);
w2 = real(w2);
w2 = sort(eval(w2));
w = sqrt(w2);
Xnorm_mat = zeros(n);
X_mat = zeros(n);
for i = 1:n
    mat = k-w2(i)*m;
    for j = 1:n;
        temp_mat = mat;
        temp_mat(j,:) = [];
        b = -temp_mat(:,j);
        temp_mat(:,j) = [];
        if det(temp_mat) ~= 0; break; end
    end
    X = temp_mat\b;
    X = [X(1:j-1); 1; X(j:end)];
    normX = X./sqrt(X'*m*X);
    X_mat(:,i) = X;
    Xnorm_mat(:,i) = normX;
end
C = Xnorm_mat'*m*x0;
D = Xnorm_mat'*m*dx0./w;
result = zeros(n,2*n);
for r = 1:n;
    for c = 1:n;
        result(r,2*c-1) = (Xnorm_mat(r,c)*C(c));
        result(r,2*c) = (Xnorm_mat(r,c)*D(c));
    end
end
disp('Normalized');disp('w');disp(w');disp('X');disp(Xnorm_mat);disp(' ');
for i = 1:n;
    fprintf('      cos%d      sin%d',i,i);
end
fprintf('\n');
disp(result);
