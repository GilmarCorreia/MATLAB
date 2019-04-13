%% DADOS DE ENTRADA

clear all;
t = 1:5:1369;

load database.mat
%% imprimindo angulo dos motores  
figure
plot(t,motor9(1:5:1369));hold on
plot(t,motor10(1:5:1369));hold on
plot(t,motor11(1:5:1369));hold on
plot(t,motor12(1:5:1369));hold on
plot(t,motor13(1:5:1369));hold on
plot(t,motor14(1:5:1369));hold on
plot(t,motor15(1:5:1369));hold on
plot(t,motor16(1:5:1369));hold on
plot(t,motor17(1:5:1369));hold on
plot(t,motor18(1:5:1369));hold on

%% REDES NEURAIS PARA CADA MOTOR
saida=[motor9;motor10;motor11;motor12;motor13;motor14;motor15;motor16;motor17;motor18]; %cada coluna representaria todos os angulos do robô em um instante de tempo

CMobtido=[XX;YY;ZZ]; % entrada do Centro de Massa

net9 = newff(CMobtido,motor9,10);
net10 = newff(CMobtido,motor10,10);

net11 = newff(CMobtido,motor11,10);
net12 = newff(CMobtido,motor12,10);

net13 = newff(CMobtido,motor13,10);
net14 = newff(CMobtido,motor14,10);

net15 = newff(CMobtido,motor15,10);
net16 = newff(CMobtido,motor16,10);

net17 = newff(CMobtido,motor17,10);
net18 = newff(CMobtido,motor18,10);

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

x = 0.79955316 +(t*0.00008);                     %
y = (0.035*pi*cos((t/1369)-((t-319)/165)))-1.2;  % Função do CENTRO DE MASSA desejado
z = (0*t) + 0.29080275;                          %

CMdesejado=[x;y;z];

motor9s = sim(net9,CMobtido(:,t));
motor10s = sim(net10,CMobtido(:,t));
motor11s = sim(net11,CMobtido(:,t));
motor12s = sim(net12,CMobtido(:,t));
motor13s = sim(net13,CMobtido(:,t));
motor14s = sim(net14,CMobtido(:,t));
motor15s = sim(net15,CMobtido(:,t));
motor16s = sim(net16,CMobtido(:,t));
motor17s = sim(net17,CMobtido(:,t));
motor18s = sim(net18,CMobtido(:,t));

total = [motor9s;motor10s;motor11s;motor12s;motor13s;motor14s;motor15s;motor16s;motor17s;motor18s];
%% imprimindo angulo dos motores

figure
plot(t,motor9s);hold on
plot(t,motor10s);hold on
plot(t,motor11s);hold on
plot(t,motor12s);hold on
plot(t,motor13s);hold on
plot(t,motor14s);hold on
plot(t,motor15s);hold on
plot(t,motor16s);hold on
plot(t,motor17s);hold on
plot(t,motor18s);hold on