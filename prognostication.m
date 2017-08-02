function [resultProbability, clearProbability] = prognostication(p,k,currentState)

resultMatrix = p^k;
clearProbability = resultMatrix(currentState,:);
resultProbability = round(100*clearProbability*100)/100;

end