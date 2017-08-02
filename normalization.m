function normalizedData = normalization(data)
[n,m] = size(data);
xm = mean(data);
s = std(data);

dataNorm = [];
for j = 1:1:m
    for i = 1:1:n
        add = ((data(i,j)-xm(1,j))/s(1,j));
        dataNorm(i,j) = add;
    end
end
normalizedData = dataNorm;
end
