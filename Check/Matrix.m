clear; clc;
syms a b c d e r vs
A = [
    3 -1 -1
    -1 3 -1
    -1 -1 3
    ].*r;
B = [
    vs
    0
    0
    ];
X = linsolve(A,B)