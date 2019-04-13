%% DADOS DE ENTRADA

clear all;
t = 1:5:1369;

load database.mat

saida=[motor9;motor10;motor11;motor12;motor13;motor14;motor15;motor16;motor17;motor18]; %cada coluna representaria todos os angulos do robô em um instante de tempo

CMobtido=[XX;YY;ZZ]; % entrada do Centro de Massa

x = 0.79955316 +(t*0.00008);                     %
y = (0.035*pi*cos((t/1369)-((t-319)/165)))-1.2;  % Função do CENTRO DE MASSA desejado
z = (0*t) + 0.29080275;                          %

CMdesejado=[x;y;z];

%% imprimindo angulo dos motores  
figure
plot(t,motor9(t));hold on
plot(t,motor10(t));hold on
plot(t,motor11(t));hold on
plot(t,motor12(t));hold on
plot(t,motor13(t));hold on
plot(t,motor14(t));hold on
plot(t,motor15(t));hold on
plot(t,motor16(t));hold on
plot(t,motor17(t));hold on
plot(t,motor18(t));hold on

%% REDES NEURAIS PARA CADA MOTOR

net9 = newff(CMobtido,motor9,1);
net10 = newff(CMobtido,motor10,1);

net11 = newff(CMobtido,motor11,1);
net12 = newff(CMobtido,motor12,1);

net13 = newff(CMobtido,motor13,1);
net14 = newff(CMobtido,motor14,1);

net15 = newff(CMobtido,motor15,1);
net16 = newff(CMobtido,motor16,1);

net17 = newff(CMobtido,motor17,1);
net18 = newff(CMobtido,motor18,1);

netdir = newff(saida,CMobtido,20);

net9 = train(net9,CMobtido,motor9);
net10 = train(net10,CMobtido,motor10);
net11 = train(net11,CMobtido,motor11);
net12 = train(net12,CMobtido,motor12);
net13 = train(net13,CMobtido,motor13);
net14 = train(net14,CMobtido,motor14);
net15 = train(net15,CMobtido,motor15);
net16 = train(net16,CMobtido,motor16);
net17 = train(net17,CMobtido,motor17);
net18 = train(net18,CMobtido,motor18);
netdir= train(netdir,saida,CMobtido);

motor9s = sim(net9,CMdesejado);
motor10s = sim(net10,CMdesejado);
motor11s = sim(net11,CMdesejado);
motor12s = sim(net12,CMdesejado);
motor13s = sim(net13,CMdesejado);
motor14s = sim(net14,CMdesejado);
motor15s = sim(net15,CMdesejado);
motor16s = sim(net16,CMdesejado);
motor17s = sim(net17,CMdesejado);
motor18s = sim(net18,CMdesejado);

total = [motor9s;motor10s;motor11s;motor12s;motor13s;motor14s;motor15s;motor16s;motor17s;motor18s];

dir = sim(netdir,total);
%% imprimindo angulo dos motores

figure
plot(t,motor9s(:,1:274));hold on
plot(t,motor10s(:,1:274));hold on
plot(t,motor11s(:,1:274));hold on
plot(t,motor12s(:,1:274));hold on
plot(t,motor13s(:,1:274));hold on
plot(t,motor14s(:,1:274));hold on
plot(t,motor15s(:,1:274));hold on
plot(t,motor16s(:,1:274));hold on
plot(t,motor17s(:,1:274));hold on
plot(t,motor18s(:,1:274));

figure
subplot(3,1,1)
plot(t,CMdesejado(1,1:274)); hold on;
plot(t,dir(1,1:274));
subplot(3,1,2)
plot(t,CMdesejado(2,1:274)); hold on;
plot(t,dir(2,1:274));
subplot(3,1,3)
plot(t,CMdesejado(3,1:274)); hold on;
plot(t,dir(3,1:274));