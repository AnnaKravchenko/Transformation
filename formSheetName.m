function f = formSheetName
global CURRENT_USER;
userID = mat2str(cell2mat(CURRENT_USER(1))); 
userName = CURRENT_USER(2);                 
f = char(strcat(userName,userID));       
end