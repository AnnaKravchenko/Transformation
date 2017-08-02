function index = checkExistUsers(name, pass)
global USERS;
uMass = USERS(:, 2:3);
[j,~]=size(uMass);
index = -1;
for i=1:1:j
    if strcmp(uMass(i,1),name) && strcmp(uMass(i,2),pass)
        index = i;
      break;
    end
end
