function mass = getUserMatrix(h_set)
mass = zeros(5,5);
mass(1,1) = str2double(get(h_set.p11,'string'));
mass(1,2) = str2double(get(h_set.p12,'string'));
mass(1,3) = str2double(get(h_set.p13,'string'));
mass(1,4) = str2double(get(h_set.p14,'string'));
mass(1,5) = str2double(get(h_set.p15,'string'));

mass(2,1) = str2double(get(h_set.p21,'string'));
mass(2,2) = str2double(get(h_set.p22,'string'));
mass(2,3) = str2double(get(h_set.p23,'string'));
mass(2,4) = str2double(get(h_set.p24,'string'));
mass(2,5) = str2double(get(h_set.p25,'string'));

mass(3,1) = str2double(get(h_set.p31,'string'));
mass(3,2) = str2double(get(h_set.p32,'string'));
mass(3,3) = str2double(get(h_set.p33,'string'));
mass(3,4) = str2double(get(h_set.p34,'string'));
mass(3,5) = str2double(get(h_set.p35,'string'));

mass(4,1) = str2double(get(h_set.p41,'string'));
mass(4,2) = str2double(get(h_set.p42,'string'));
mass(4,3) = str2double(get(h_set.p43,'string'));
mass(4,4) = str2double(get(h_set.p44,'string'));
mass(4,5) = str2double(get(h_set.p45,'string'));

mass(5,1) = str2double(get(h_set.p51,'string'));
mass(5,2) = str2double(get(h_set.p52,'string'));
mass(5,3) = str2double(get(h_set.p53,'string'));
mass(5,4) = str2double(get(h_set.p54,'string'));
mass(5,5) = str2double(get(h_set.p55,'string'));