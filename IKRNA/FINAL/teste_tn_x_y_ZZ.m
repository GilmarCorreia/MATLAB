%% teste com consideração de tempos anteriores, x modelado como uma reta e desconsiderando y e z.

clear all, close all

%% DADOS DE ENTRADA
load robotData.mat
t = 1:5:1369;
motor9 = MOTOR(1,1:length(CM)-2);
motor10 = MOTOR(2,1:length(CM)-2);
motor11 = MOTOR(3,1:length(CM)-2);
motor12 = MOTOR(4,1:length(CM)-2);
motor13 = MOTOR(5,1:length(CM)-2);
motor14 = MOTOR(6,1:length(CM)-2);
motor15 = MOTOR(7,1:length(CM)-2);
motor16 = MOTOR(8,1:length(CM)-2);
motor17 = MOTOR(9,1:length(CM)-2);
motor18 = MOTOR(10,1:length(CM)-2);
motor_treino = [motor9;motor10;motor11;motor12;motor13;motor14;motor15;motor16;motor17;motor18];

XX = CM(1,1:length(CM)-2);
YY = CM(2,1:length(CM)-2);
ZZ = CM(3,1:length(CM)-2);

CMobtido=[XX;YY;ZZ];

x = 0.7995+0.00008*t;                          %
y = (0.03*pi*cos((t/length(CM))-((t-319)/165)))-1.2;  % Função do CENTRO DE MASSA desejado
z = 0*t + 0.29080275;                          %

CMdesejado=[x; y; z];
%% cria dado para treino com t, t-1, t-2

index = 1:1:length(MOTOR);
i=1;
while any(index(3:length(index)))
    tn = find(index);
    tn = tn(randi([1 length(tn)]));    
    if tn == 5
        a=1;
    end
    if  tn > 2
        motor_t(:,i) = [MOTOR(:,tn); MOTOR(:,tn-1); MOTOR(:,tn-2)];  
        index(tn) = 0;
        i = i+1;
    end
end
motor_treino = motor_t;

%% REDES NEURAIS 

netDireta = newff(motor_treino,CMobtido,20);
netDireta = train(netDireta,motor_treino,CMobtido);

netInversa = newff(CMobtido,motor_treino,10);
netInversa = train(netInversa,CMobtido,motor_treino);

a0 = sim(netInversa,CMobtido(:,t));
a1 = sim(netDireta,a0);   

%% imprimindo angulo dos motores

figure
plot(t,a0(1:10,1:274));

figure
plot(t,a1(2,1:274));