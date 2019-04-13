clear all;

t = 1:5:1369;

load database.mat

saida=[motor9;motor10;motor11;motor12;motor13;motor14;motor15;motor16;motor17;motor18]; %cada coluna representaria todos os angulos do robô em um instante de tempo

CMobtido=YY%[XX;YY;ZZ]; % entrada do Centro de Massa

x = 0.79955316 +(t*0.00008);                          %
y = (0.035*pi*cos((t/1369)-((t-319)/165)))-1.2;  % Função do CENTRO DE MASSA desejado
z = (0*t) + 0.29080275;%

CMdesejado=y;%[x;y;z];

%% imprimindo angulo dos motores  

% figure
% subplot(2,2,1);
% plot(t,motor9(t)); m1 = 'Motor 9';hold on
% plot(t,motor10(t));m2 = 'Motor 10';hold on
% plot(t,motor11(t));m3 = 'Motor 11';hold on
% plot(t,motor12(t));m4 = 'Motor 12';hold on
% plot(t,motor13(t));m5 = 'Motor 13';hold on
% plot(t,motor14(t));m6 = 'Motor 14';hold on
% plot(t,motor15(t));m7 = 'Motor 15';hold on
% plot(t,motor16(t));m8 = 'Motor 16';hold on
% plot(t,motor17(t));m9 = 'Motor 17';hold on
% plot(t,motor18(t));m10 = 'Motor 18';
% legend(m1,m2,m3,m4,m5,m6,m7,m8,m9,m10);
% subplot(2,2,2);
% plot(t,YY(t));

%% REDES NEURAIS PARA CADA MOTOR

netCINdir = newff(saida,CMobtido,20);
netCINdir = train(netCINdir,saida,CMobtido);

netCINinv = newff(CMobtido,saida,7);
netCINinv = train(netCINinv,CMobtido,saida);

a0 = sim(netCINinv,CMdesejado);
a1 = sim(netCINdir,a0);   

%% imprimindo angulo dos motores
figure
plot(t,a0(:,1:274));

figure
subplot(3,1,1);
plot(t,CMdesejado(1,1:274)); hold on;
plot(t,a1(1,1:274));
% %legend(m1,m2,m3,m4,m5,m6,m7,m8,m9,m10);
% subplot(3,1,2);
% plot(t,CMdesejado(2,1:274)); hold on;
% plot(t,a1(2,1:274));
% subplot(3,1,3);
% plot(t,CMdesejado(3,1:274)); hold on;
% plot(t,a1(3,1:274));