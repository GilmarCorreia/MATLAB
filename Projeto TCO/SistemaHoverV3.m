%% Exemplo Hover
clear all; close all; clc;

t = 0:0.25:20;
tempo = t;

%Setando aceleração frontal e angular
tau_u = 0.1*(heaviside(tempo));
tau_r = 0*heaviside(tempo);
beta = 1.2;

%% Colocando o valores iniciais de posição
x0 = 0;
y0 = 0;
psi0 = 45;
u0 = 0.5;
v0 = 0;
r0 = 0;

% Faz o cálculo da Dinâmica do Hover dado uma função de tau_u e outra de tau_r
% passa-se como referência o estado inicial do Hover
[x,y,psi,u,v,r] = DinamicaHoverEDOsGraus(t,tau_u,tau_r,beta, [x0 y0 psi0 u0 v0 r0]');
%[x,y,psi,u,v,r] = DinamicaHoverEDOsRad(t,tau_u,tau_r,beta, [x0 y0 psi0 u0 v0 r0]');
    

%% Plotando os gráficos de entrada e saída

figure(1);
    HoverInOut(t,tau_u,tau_r,beta,x,y,psi,u,v,r, 12, 3);
    pause(2.0)
    hold off
    
%% Simulando o Hover
figure(2);
    SimuladorHoverGraus(t,200,x,x0,y,y0,psi);    
    %SimuladorHover(t,200,x,x0,y,y0,psi);  
    pause(2.0)
    hold off
    
