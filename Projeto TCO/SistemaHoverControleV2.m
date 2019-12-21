%% Como resolver o controle
clear all; close all; clc;

h = 0.01;
max = 30;
t = 0:h:max;

%% Setando aceleração frontal e angular inicial
tau_u = zeros(1,length(t));
tau_u_r = 0.1;
tau_r = zeros(1,length(t));
tau_r_r = 0;
beta = 1.2;

%% Setando as posições iniciais e de referência

%ponto inicial = [x, y,psi,u,v,r]
       p       = [1;-1; 1 ;0;0;0];
       %p       = [-1.5;1; 1 ;0;0;0];
    p_initial  = p;

%trajetória de referência = [x_r,y_r,psi_r,u_r,v_r,r_r]
         traj_ref         = [ 0 ; 0 ; 0.78;0.5; 0 ; 0 ];
        %traj_ref         = [ 0 ; 0 ; 2.09;0.5; 0 ; 0 ];
[x_ref,y_ref,psi_ref,u_ref,v_ref,r_ref] = DinamicaHoverEDOsWT(t,tau_u_r,tau_r_r,beta, traj_ref);

%variável para guardar os erros ao longo do tempo
errorVar = zeros(6,length(t));

%% Setando as Matrizes B, Q e R

B = [0 0 0 0 0 0;0 0 0 0 0 0;0 0 0 0 0 0;0 0 0 1 0 0;0 0 0 0 0 0;0 0 0 0 0 1];
Q = 100*eye(6);
R = 10*eye(6);

%% Realizando o controle e cálculo da matriz A

for i = 1:length(t)-1
    
    traj_ref(1) = x_ref(i);
    traj_ref(2) = y_ref(i);
    traj_ref(3) = psi_ref(i);
    traj_ref(4) = u_ref(i);
    traj_ref(5) = v_ref(i);
    traj_ref(6) = r_ref(i);
    
    % calculo do vetor de erro
    e = (p-traj_ref);
    % salva o erro no instante t(i)
    errorVar(:,i) = e;
        
    % Cálculo da Matriz A
    if (e(3) == 0)
        a1 =  - (traj_ref(4)*sin(traj_ref(3))+traj_ref(5)*cos(traj_ref(3)));
        a2 = (traj_ref(4)*cos(traj_ref(3))-traj_ref(5)*sin(traj_ref(3)));
    else
        a1 = ((cos(e(3))-1) * (traj_ref(4)*cos(traj_ref(3))-traj_ref(5)*sin(traj_ref(3))) - (sin(e(3))*(traj_ref(4)*sin(traj_ref(3))+traj_ref(5)*cos(traj_ref(3)))))/e(3);
        a2 = ((cos(e(3))-1) * (traj_ref(4)*sin(traj_ref(3))+traj_ref(5)*cos(traj_ref(3))) + (sin(e(3))*(traj_ref(4)*cos(traj_ref(3))-traj_ref(5)*sin(traj_ref(3)))))/e(3);
    end
    a3 = cos(e(3)+traj_ref(3));
    a4 = sin(e(3)+traj_ref(3));
    a5 = e(6)+traj_ref(6);
    A = [0 0 a1 a3 -a4 0;0 0 a2 a4 a3 0;0 0 0 0 0 1;0 0 0 0 a5 traj_ref(5);0 0 0 -a5 -beta -traj_ref(4);0 0 0 0 0 0];

    % Obtenção da matriz de controle mu
    K = lqr(A,B,Q,R);
    mu = -K*e;
    
    % Cálculo das acelerações frontais e angulares  
    tau_u(i+1) = mu(4) + tau_u_r;
    tau_r(i+1) = mu(6) + tau_r_r;
    
    % Cálculo dos Próximos Estados
    time = t(i):h:(t(i)+2*h);
    [x,y,psi,u,v,r] = DinamicaHoverEDOsWT(time,tau_u(i+1),tau_r(i+1),beta, p);
    
    % Computa o vetor do ponto no próximo estado
    p = [x(2);y(2);psi(2);u(2);v(2);r(2)];
end

% Plota o erro de x, y, psi, u, v e r
figure(1);
    lineWidth = 3;
    set(gcf, 'Position', get(0, 'Screensize'));
    fontSize = 14;
    graph1 = subplot(1,2,1);
        plot(t, errorVar(1,:),t, errorVar(2,:),t, errorVar(3,:),'linewidth',lineWidth);
        legend({'e_x(t)','e_y(t)','e_\psi(t)'},'FontSize',fontSize);
        title(graph1,{'Gráfico dos Erros das Posições do ', 'HoverCraft em Relação à Referência'},'FontSize',fontSize);
        xlabel('t(s)','FontSize',fontSize);
        ylabel('Erro relativo à Posição (m)','FontSize',fontSize);
        grid;
    graph2 = subplot(1,2,2);
        plot(t, errorVar(4,:),t,errorVar(5,:),t,errorVar(6,:),'linewidth',lineWidth);
        legend({'e_u(t)','e_v(t)','e_r(t)'},'FontSize',fontSize);
        title(graph2,{'Gráfico dos Erros das Velocidades do' , 'HoverCraft em Relação à Referência (m/s)'},'FontSize',fontSize);
        xlabel('t(s)','FontSize',fontSize);
        ylabel('Erro relativo à Velocidade','FontSize',fontSize);
        grid;
    pause(2.0);
    hold off;
    
% Faz o cálculo da Dinâmica do Hover dado uma função de tau_u e outra de tau_r
% passa-se como referência o estado inicial do Hover
[x,y,psi,u,v,r] = DinamicaHoverEDOsRad(t,tau_u,tau_r,beta, p_initial);


figure(2);
    set(gcf, 'Position', get(0, 'Screensize'));
    plot(x_ref,y_ref,x,y,'linewidth',lineWidth);
    legend({'referência','hovercraft'},'FontSize',fontSize);
    title({'Trajetória de Referência ', 'e do HoverCraft'},'FontSize',fontSize);
    xlabel('x(m)','FontSize',fontSize);
    ylabel('y(m)','FontSize',fontSize);
    grid
    pause(2.0)
    hold off
    
% Imprime os gráficos de entrada e saída da dinâmica do hover
figure(3);
    set(gcf, 'Position', get(0, 'Screensize'));
    HoverInOut(t,tau_u,tau_r,beta,x,y,psi,u,v,r, 12, 3);
    pause(2.0)
    hold off

% SImula o Hover
figure(4);
    set(gcf, 'Position', get(0, 'Screensize'));
    SimuladorHover(t,200,x, p_initial(1),y,p_initial(2),psi);  
    pause(2.0)
    hold off





