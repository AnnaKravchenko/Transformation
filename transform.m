function transform
%   global variable initialization
global USERS;
global DATA;
%   create waitbar
    wb = waitbar(0,'Завантаження...');
    set(wb,'Name','Будь ласка, зачекайте');
%   load information about all registered users
[~,~,USERS] = xlsread('data.xlsx','users');
    waitbar(1/2);
%   load raw data "Eating & Health Module"
DATA = xlsread('data.xlsx','mainData');
%   load data about the "stay in the system" marker of the last session 
[~,userInfo,~] = xlsread('data.xlsx','stayIn');
    delete(wb);
%	open autorization window    
H = open('enter.fig');
%   get handles of the window
handles_enter = guihandles(H);
if ~isempty(userInfo)
    %   marker was marked in the last session
    name = char(userInfo(1));
    pass = char(userInfo(2));
    set(handles_enter.name,'string',name);
    set(handles_enter.pass,'string',pass);
end
set(handles_enter.checkbox,'Value',1)
%   set callback function to the button
set(handles_enter.btnOk,'Callback',{@btnOk_Callback,handles_enter})
set(handles_enter.btnReg,'Callback',{@btnReg_Callback,handles_enter})

%   callback function for button 'ok' window 'enter'
function btnOk_Callback(~,~,h_enter)
    %   global variable initialization
    global CURRENT_USER;
    global USERS;
    %   get input data
    name = get(h_enter.name,'String');
    pass = get(h_enter.pass,'String');
    %   validate data
    if  ~checkInput(name)||~checkInput(pass)
        p = 0;
    else
        existUserIndex = checkExistUsers(name,pass);
        if existUserIndex~=-1
            %   combination login-pass unique
            CURRENT_USER = USERS(existUserIndex,:);
            if  isequal(get(h_enter.checkbox,'Value'),1)
                xlswrite('data.xlsx',{name,pass},'stayIn')
            else
                %   clear fields
                xlswrite('data.xlsx',{' ',' '},'stayIn')
            end
            %   open main window
            delete(h_enter.win_enter)
            h = open('main2.fig');
            %   pointers to objects of the main window write in the structure handles
            handles = guihandles(h);
            %   default setting
            par1.mode = 'auto';
            par1.period = 3;
            %   save structure par1
            guidata(handles.win_main,par1)
            %   set callback function to the button
            set(handles.btnTest,'Callback',{@btnTest_Callback,handles})
            set(handles.btnResult,'Callback',{@btnResult_Callback,handles})
            set(handles.btnProg,'Callback',{@btnProg_Callback,handles})
            set(handles.btnSet,'Callback',{@btnSet_Callback,handles})
            set(handles.btnHlp,'Callback',{@btnHlp_Callback,handles})
            set(handles.btnClose,'Callback',{@btnClose_Callback,handles})
        else
            errordlg('Комбінація <логін; пароль> не існує в системі','Помилка')
        end
    end

%   callback function for button 'registration' window 'enter'
function btnReg_Callback(~,~,h_enter)
    %   open registration window
    h = open('registration.fig');
    %   instruction
    helpdlg('Для реєстрації заповніть всі поля форми. Довжина догіну та пароля варіюється в межах від 6 до 25 символів. Зріст вимірюється в сантиметрах, від 50 до 275.',...
        'Інструкція');
    h_reg = guihandles(h);
    set(h_reg.m,'Value',1)
    %   set callback function to the button
    set(h_reg.btnRegOk,'Callback',{@btnRegOk_Callback,h_reg,h_enter})
    set(h_reg.btnRegCancel,'Callback',{@btnRegCancel_Callback,h_reg})
    
%   callback function for button 'cancel' window 'registration'
function btnRegCancel_Callback(~,~,h_reg)
    %   close window 'registration'
    delete(h_reg.win_reg)
    
%   callback function for button 'ok' window 'registration'
function btnRegOk_Callback(~,~,h_reg,h_enter)
    %   global variable initialization
    global USERS;
    global CURRENT_USER;
    %   get input data
    name = get(h_reg.regName,'String');
    pass1 = get(h_reg.regPass1,'String');
    pass2 = get(h_reg.regPass2,'String');
    height = str2double(get(h_reg.regHei,'String'));
    if get(h_reg.m,'Value')
        par.regSex='m';
        sex = 'm';
    elseif get(h_reg.w,'Value')
        par.regSex='w';
        sex = 'w';
    end
    %   validate input data
    if  ~checkInput(name)||~checkInput(pass1)||~checkInput(pass2)
        l = 0;
    elseif isnan(height)||height<50|| height>275
        warndlg('Помилка введення поля "Зріст"','Помилка')
    elseif ~strcmp(pass1,pass2)
        warndlg('Паролі не співпадають','Помилка')
    else
        existUserIndex = checkExistUsers(name,pass1);
        if existUserIndex ~= -1
            warndlg('Комбінація <логін; пароль> не є унікальною','Помилка')
        else
            %   create waitbar
            wb = waitbar(0,'Завантаження...');
            set(wb,'Name','Будь ласка, зачекайте');
            waitbar(1/6);
            [j,~] = size(USERS);
            %   create structure for save new user data
            mass4save = {int2str(j+1),name,pass1,num2str(height),sex};
            position = strcat('A',int2str(j+1));
            waitbar(2/6);
            xlswrite('data.xlsx',mass4save,'users',position);
            waitbar(3/6);
            %   update data
            [~,~,USERS] = xlsread('data.xlsx','users');
            waitbar(4/6);
            %   set current user
            CURRENT_USER = USERS(j+1,:);
            waitbar(5/6);
            %   create new sheet for new user 
            xlswrite('data.xlsx',{'New User'},formSheetName)
            waitbar(6/6);
            delete(wb);
            %   save structure par
            guidata(h_reg.win_reg,par)
            par = guidata(h_reg.win_reg);
            par.Hei = height;
            %   close window 'registration'
            delete(h_reg.win_reg)
            %   closw window 'enter'
            delete(h_enter.win_enter)
            %   open window 'main'
            h = open('main2.fig');
            %   pointers to objects of the main window write in the structure handles
            handles = guihandles(h);
            par1.mode = 'auto';
            par1.period = 3;
            guidata(handles.win_main,par1)
            set(handles.btnTest,'Callback',{@btnTest_Callback,handles})
            set(handles.btnResult,'Callback',{@btnResult_Callback,handles})
            set(handles.btnProg,'Callback',{@btnProg_Callback,handles})
            set(handles.btnSet,'Callback',{@btnSet_Callback,handles})
            set(handles.btnHlp,'Callback',{@btnHlp_Callback,handles})
            set(handles.btnClose,'Callback',{@btnClose_Callback,handles})
        end
    end

%   callback function for button "Закрыть" on the main window
function btnClose_Callback(~,~,handles)
    delete(handles.win_main)

 function btnHlp_Callback(~,~,~)
     %   global variable initialization
     global README;
     README = 'userManual.pdf';
     %   open pdf file
     open(README)

function btnTest_Callback(~,~,~)
    H = open('test.fig');
    h_test = guihandles(H);
    par = guidata(h_test.win_test);
    guidata(h_test.win_test,par)
    set(h_test.btnCancelTest,'Callback',{@btnCancelTest_Callback,h_test})
    set(h_test.btnSaveTest,'Callback',{@btnSaveTest_Callback,h_test})

function btnCancelTest_Callback(~,~,handles)
    delete(handles.win_test)
 
function btnSaveTest_Callback(~,~,h_test)
    %   global variable initialization
    global CURRENT_USER;
    weight = str2double(get(h_test.wei,'String'));
    Ff = round(str2double(get(h_test.Ff,'String')));
    %check input
    if weight<10 || weight>730 || isnan(weight)
        warndlg('Вага має належати діапазону [10; 730] кілограмів','Помилка')
    elseif Ff<0 || Ff>21 || isnan(Ff)
        warndlg('Кількість має належати діапазону [0; 21] разів','Помилка')
    else
        if Ff == 0
            FfCounter = -1;
            Ff = 2;
        else
            FfCounter = Ff;
            Ff = 1;
        end
        if get(h_test.yMeat,'Value')
            meat = 1;
        elseif get(h_test.nMeat,'Value')
            meat = 2;
        end
        if get(h_test.yMilk,'Value')
            milk = 1;
        elseif get(h_test.nMilk,'Value')
            milk = 2;
        end
        if get(h_test.ySweetDrinks,'Value')
            sDrinks = 1;
        elseif get(h_test.nSweetDrinks,'Value')
            sDrinks = 2;
        end
        if get(h_test.yNoWater,'Value')
            noWater = 1;
        elseif get(h_test.nNoWater,'Value')
            noWater = 2;
        end
        if get(h_test.type1,'Value')
            diet = 1;
        elseif get(h_test.type2,'Value')
            diet = 2;
        elseif get(h_test.type3,'Value')
            diet = 3;
        end
        wb = waitbar(0,'Загрузка...');
        set(wb,'Name','Пожалуйста, подождите');
        waitbar(1/5);
        hei=cell2mat(CURRENT_USER(4));
        bmi = weight/((hei/100)^2);
        struct4save = {hei, weight, bmi, milk, meat, Ff, FfCounter, diet, noWater, sDrinks};
        waitbar(2/5);
        waitbar(3/5);
        userData = xlsread('data.xlsx',formSheetName);
        waitbar(4/5);
        [j,~] = size(userData);
        xlRange = strcat('A',num2str(j+1));
        xlswrite('data.xlsx',struct4save,formSheetName,xlRange);
        waitbar(5/5);   
        delete(wb);
        delete(h_test.win_test)
    end

function btnResult_Callback(~,~,~)
    try
        wb = waitbar(0,'Завантаження...');
        set(wb,'Name','Будь ласка, зачекайте');
        userData = xlsread('data.xlsx',formSheetName);
        [col,row]=size(userData);
        if row == 11 && ~isnan(userData(col,row))
            result = userData(col,11);
        elseif isnan(userData(col,row)) || row == 10
            waitbar(1/8);
            mainData = xlsread('data.xlsx','mainData');
            waitbar(2/8);
            waitbar(3/8);
            currentData = [mainData(:,2:11);userData(:,1:10)];
            waitbar(4/8);
            dataNorm = normalization(currentData);
            st1 = dataNorm(4186,:);
            st2 = dataNorm(4194,:);
            st3 = dataNorm(4191,:);
            st4 = dataNorm(4202,:);
            st5 = dataNorm(5262,:);
            waitbar(5/8);
            IDX = kmeans(dataNorm, [],'distance','cityblock','start',[st1;st2;st3;st4;st5]);
            [a,~] = size(IDX);
            result = IDX(a);
        end
        h = open('result.fig');
        h_res = guihandles(h);
        waitbar(6/8);
        par.id= col;
        par.state = result;
        guidata(h_res.win_result,par);
        [color, text] = colorControl(result, h_res);
        set(h_res.currentState,'BackgroundColor',color);
        set(h_res.currentState,'String',text);
        waitbar(7/8);
        set(h_res.btnResOk,'Callback',{@btnResOk_Callback,h_res})
        set(h_res.btnResSave,'Callback',{@btnResSave_Callback,h_res})
        delete(wb);
    catch
        delete(wb);
        helpdlg('Для початку відвідайте вікно з опитуванням','Результат')
    end

function btnResOk_Callback(~,~,h_res)
    par=guidata(h_res.win_result);
    xlRange = strcat('K',int2str(par.id));
    xlswrite('data.xlsx',par.state,formSheetName,xlRange);
    delete(h_res.win_result)

function btnResSave_Callback(~,~,h_res)
    par=guidata(h_res.win_result);
    if get(h_res.state1,'Value')
         par.state = 1;
     elseif get(h_res.state2,'Value')
         par.state = 2;
     elseif get(h_res.state3,'Value')
         par.state = 3;
     elseif get(h_res.state4,'Value')
         par.state = 4;
     elseif get(h_res.state5,'Value')
         par.state = 5;
    end
    xlRange = strcat('K',int2str(par.id));
    xlswrite('data.xlsx',par.state,formSheetName,xlRange);
    delete(h_res.win_result)

function btnSet_Callback(~,~,handles)
    allMatrix = xlsread('data.xlsx','matrix');
    h = open('setting2.fig');
    h_set = guihandles(h);
    par1=guidata(handles.win_main);
    par.counter = 1;
    try
        set(h_set.period,'string', par1.period)
        if strcmp(par1.mode,'manual')
            par.mode = 'manual';
            setMatrix(h_set, par1.p)
        else
            par.mode = 'auto';
        end
    catch
        warn = 1
    end
    guidata(h_set.win_set,par)
    set(h_set.btnL,'Callback',{@btnL_Callback,h_set,allMatrix})
    set(h_set.btnAuto,'Callback',{@btnAuto_Callback,h_set})
    set(h_set.btnR,'Callback',{@btnR_Callback,h_set,allMatrix})
    set(h_set.btnSaveSet,'Callback',{@btnSaveSet_Callback,h_set,handles,allMatrix})
    set(h_set.btnCancelSet,'Callback',{@btnCancelSet_Callback,h_set})

function btnCancelSet_Callback(~,~,h_set)
    delete(h_set.win_set)
    
function btnL_Callback(~,~,h_set,matrix)
    par=guidata(h_set.win_set);
    counter = par.counter - 5;
    par.counter = counter;
    par.mode = 'manual';
    guidata(h_set.win_set,par)
    try
        setMatrix(h_set, matrix(par.counter:par.counter+4,:))
    catch
        warndlg('Варіанти матриць скінчились','Налаштування');
        par.counter = counter + 5;
        guidata(h_set.win_set,par)
    end

function btnR_Callback(~,~,h_set,matrix)
    par=guidata(h_set.win_set);
    counter = par.counter+5;
    par.counter = counter;
    par.mode = 'manual';
    guidata(h_set.win_set,par)
    try
        setMatrix(h_set, matrix(counter:counter+4,:))
    catch
        warndlg('Варіанти матриць скінчились','Налаштування');
        par.counter = counter - 5;
        guidata(h_set.win_set,par)
    end

function btnAuto_Callback(~,~,h_set)
    par=guidata(h_set.win_set);
    mass = ['.....';'.....';'.....';'.....';'.....'];
    setMatrix(h_set, mass)
    par.mode = 'auto';
    guidata(h_set.win_set,par);

function btnSaveSet_Callback(~,~,h_set,h_main,mass)
    try 
        par1=guidata(h_main.win_main);
        par = guidata(h_set.win_set);
        par1.mode = par.mode;
        period = round(str2double(get(h_set.period,'String')));
        if period < 1 || period > 31 || isnan(period)
            warndlg('Період має лежати в діапазоні [1;30]','Помилка вводу періодy');
        else
            par1.period = period;
            if strcmp(par.mode,'manual')
                matrix1 = mass(par.counter:par.counter+4,:);
                matrix2 = getUserMatrix(h_set);
                if isequal(matrix1,matrix2)
                    resultMatrix = matrix1;
                else
                    resultMatrix = matrix2;
                    checkMatrixInput(resultMatrix)
                    [col,~]=size(mass);
                    xlswrite('data.xlsx',resultMatrix,'matrix',strcat('A',int2str(col+1)))
                end
                par1.p = resultMatrix;
            else
                par1.mode = 'auto';
                par1.p = mass(1:15,:);
            end
            guidata(h_main.win_main,par1);
            delete(h_set.win_set)
        end
    catch
        warndlg('Елементи матриці мають бути числами, а сума елементів кожного рядка має бути рівна 1','Помилка вводу матриці')
    end
 
 
function  btnProg_Callback(~,~,h_main)
    try
        par1 = guidata(h_main.win_main);
        k = par1.period;
        mode = par1.mode;
        userData = xlsread('data.xlsx',formSheetName);
        [col, ~] = size(userData);
        bmi = userData(col,3);
        Ff = userData(col,6);
        sweet = userData(col,10);
        currentState = userData(col,11);
        if strcmp(mode,'auto')
            mass = xlsread('data.xlsx','matrix'); 
            p = defineStochasticMatrix(bmi,Ff,sweet,mass(1:15,:));
        else 
            p = par1.p;
        end
        [resultProbability, clearProbability] = prognostication(p,k,currentState);
        h = open('prog2.fig');
        h_prog = guihandles(h);
        forTxt = strcat('через ',strcat(int2str(k),' тижні(-ів):'));
        set(h_prog.periodTxt,'String',forTxt)
        set(h_prog.st1,'String',strcat(int2str(resultProbability(1)),'%'))
        set(h_prog.st2,'String',strcat(int2str(resultProbability(2)),'%'))
        set(h_prog.st3,'String',strcat(int2str(resultProbability(3)),'%'))
        set(h_prog.st4,'String',strcat(int2str(resultProbability(4)),'%'))
        set(h_prog.st5,'String',strcat(int2str(resultProbability(5)),'%'))
        data = userData(:,11);
        set(h_prog.btnPlot,'Callback',{@btnPlot_Callback,data,k,clearProbability})
        set(h_prog.btnProgClose,'Callback',{@btnProgClose_Callback,h_prog})
    catch
        helpdlg('Для побудови прогнозу необхідно визначити результат останного опитування','Прогноз')
    end

function btnProgClose_Callback(~,~,h_prog)
    delete(h_prog.win_prog)
        
function btnPlot_Callback(~,~, data,k,colors)
    [count,~] = size(data);
    for i = 1:1:count
        helpPoints(i) = i;
    end
    data = data.*-1;
    figure('Color', 'w', 'MenuBar', 'none','NumberTitle', 'off', 'Name', 'Графік прогнозу')%'Resize', 'off'
    plot([0,1,2,3,4,5,6],[0,-1,-2,-3,-4,-5,-6],'w')
    hold on;
    plot(helpPoints,data,'bo-','MarkerSize',7,'MarkerFaceColor',[1,0,0.5])
    x = [helpPoints(count),helpPoints(count)+k];
    grid on
    plot(x,[data(count),-1],'b--o','color',[0.21,0.35,1,colors(1)],'LineWidth',1.5)
    plot(x,[data(count),-2],'b--o','color',[0.21,0.35,1,colors(2)],'LineWidth',1.5)
    plot(x,[data(count),-3],'b--o','color',[0.21,0.35,1,colors(3)],'LineWidth',1.5)
    plot(x,[data(count),-4],'b--o','color',[0.21,0.35,1,colors(4)],'LineWidth',1.5)
    plot(x,[data(count),-5],'b--o','color',[0.21,0.35,1,colors(5)],'LineWidth',1.5)
    plot(helpPoints(count)+k+1,-3,'w')
    title('Днаміка стану здоров`я в часі'); 
    xlabel('Тижні'); 
    ylabel('Стани здоров`я'); 