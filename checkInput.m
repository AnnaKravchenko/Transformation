function f = checkInput(str)
 f = false;
 x = double(str);
 if sum(x<48)+sum(x>58 & x<65)+sum(x>90 & x<97)+sum(x>122)>0
     warndlg('����/������ ����� ������ ���� ������� 0-9, a-z, A-Z','�������')
 elseif sum(x>47 & x<58)<1
     warndlg('����/������ ����� ������ ���� � 1 ������ � �������� 0-9','�������')
 elseif sum(x>64 & x<91)<1
     warndlg('����/������ ����� ������ ���� � 1 ������ � �������� A-Z','�������')    
 elseif sum(x>96 & x<123)<1
     warndlg('����/������ ����� ������ ���� � 1 ������ � �������� a-z','�������')    
 elseif isempty(x)||length(str)<6||length(str)>26
     warndlg('����/������ ����� ������ �� 6 �� 25 ������� � �������� 0-9, a-z, A-Z','�������')         
 else
     f = true;
 end
end
