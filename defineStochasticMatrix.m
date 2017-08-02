function stochasticMatrix = defineStochasticMatrix(bmi,Ff,sweet,matrix)
if bmi>=18 && bmi<=25 && (Ff == 2 || sweet == 2)
    stochasticMatrix = matrix(1:5,:);
elseif (bmi<18 || bmi>25) && ~(Ff == 2 && sweet == 2)
    stochasticMatrix = matrix(11:15,:);
else 
    stochasticMatrix = matrix(6:10,:);
end

