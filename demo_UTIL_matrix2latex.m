clear;
clc;
close all;
a = randn(16,5);
rowLabels = {'1st row', '2nd row', '2nd row', '2nd row', '2nd row', '2nd row', '2nd row', '2nd row', '2nd row', '2nd row', '2nd row', '2nd row', '2nd row', '2nd row', '2nd row', '2nd row'};
colLabels = {'1st col', '2nd col', '3rd col', '4th col', '5th col'};
UTIL_matrix2latex(a, 'out.tex', 'rowLabels', rowLabels, 'columnLabels', colLabels, 'size', 'tiny');