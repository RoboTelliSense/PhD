a = [1 2 3;4 5 6]
rowLabels = {'1st row', '2nd row'};
colLabels = {'1st col', '2nd col', '3rd col'};
UTIL_matrix2latex(a, 'out.tex', 'rowLabels', rowLabels, 'columnLabels', colLabels);