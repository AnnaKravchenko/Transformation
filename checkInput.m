function f = checkInput(str)
 f = false;
 x = double(str);
 if sum(x<48)+sum(x>58 & x<65)+sum(x>90 & x<97)+sum(x>122)>0
     warndlg('Логін/пароль мають містити лише символи 0-9, a-z, A-Z','Помилка')
 elseif sum(x>47 & x<58)<1
     warndlg('Логін/пароль мають містити хоча б 1 символ з діапазону 0-9','Помилка')
 elseif sum(x>64 & x<91)<1
     warndlg('Логін/пароль мають містити хоча б 1 символ з діапазону A-Z','Помилка')    
 elseif sum(x>96 & x<123)<1
     warndlg('Логін/пароль мають містити хоча б 1 символ з діапазону a-z','Помилка')    
 elseif isempty(x)||length(str)<6||length(str)>26
     warndlg('Логін/пароль мають містити від 6 до 25 символів з діапазону 0-9, a-z, A-Z','Помилка')         
 else
     f = true;
 end
end
