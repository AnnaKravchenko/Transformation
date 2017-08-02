function checkMatrixInput(mass)
if isnan(mass)
    error('1')
else
    for i = 1:5
        if sum(abs(mass(i,:))) ~= 1
            error('2')
        end
    end
end
end