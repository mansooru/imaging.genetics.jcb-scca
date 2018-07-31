function Penalty = get_connectivity(data,alpha)
X1 = corr(data).^alpha;
diag_X1=diag(diag(X1));
X1=X1-diag_X1;
L1=diag(sum(X1,2));
Penalty=L1-X1;
end