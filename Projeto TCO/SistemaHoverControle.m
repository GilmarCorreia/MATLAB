%% Como resolver o controle
clear all; close all; clc;

h = 0.01;
max = 30;
t = 0:h:max;

%% Setando acelera��o frontal e angular inicial
tau_u = zeros(1,length(t));
tau_u_r = 0.1;
tau_r = zeros(1,length(t));
tau_r_r = 0;
beta = 1.2;

%% Setando as posi��es iniciais e de refer�ncia

%ponto inicial = [x, y,psi,u,v,r]
       p       = [1;-1; 1 ;0;0;0];
       %p       = [15;20; 1 ;0;0;0];
    p_initial  = p;

%trajet�ria de refer�ncia = [x_r,y_r,psi_r,u_r,v_r,r_r]
         traj_ref         = [ 0 ; 0 ; 0.78;0.5; 0 ; 0 ];

[x_ref,y_ref,psi_ref,u_ref,v_ref,r_ref] = DinamicaHoverEDOsWT(t,tau_u_r,tau_r_r,beta, traj_ref);

%vari�vel para guardar os erros ao longo do tempo
errorVar = zeros(6,length(t));

%% Setando as Matrizes B, Q e R

B = [0 0 0 0 0 0;0 0 0 0 0 0;0 0 0 0 0 0;0 0 0 1 0 0;0 0 0 0 0 0;0 0 0 0 0 1];
Q = 100*eye(6);
R = 10*eye(6);

%% Realizando o controle e c�lculo da matriz A
% calculo do vetor de erro
    e = (p-traj_ref);
    
for i = 1:length(t)-1
    
    traj_ref(1) = x_ref(i);
    traj_ref(2) = y_ref(i);
    traj_ref(3) = psi_ref(i);
    traj_ref(4) = u_ref(i);
    traj_ref(5) = v_ref(i);
    traj_ref(6) = r_ref(i);
    
    % salva o erro no instante t(i)
    errorVar(:,i) = e;
        
    % Obten��o da matriz de controle Mu
    [K,S,l] = lqr(A_new(e,traj_ref,beta),B,Q,R);
    mu = -K*e;

    % Resolu��o da equa��o e_dot = A(e) e + B mu
    % Como o erro � calculado a cada instante de tempo, ent�o a edo
    % necessita ser calculado com o tempo inicial de t(i), e o erro do
    % pr�ximo estado ser� em t(i+1), portanto sempre ser� em 2
    time = t(i):h:(t(i)+5*h);
    
    [time_e,erro] = ode45(@(time_e,erro) (A_new(erro,traj_ref,beta)*erro + B*mu), time, e);
    e = erro(2,:)';  
    
    x_next = e(1) + x_ref(i+1);
    y_next = e(2) + y_ref(i+1);
    psi_next = e(3) + psi_ref(i+1);
    u_next = e(4) + u_ref(i+1);
    v_next = e(5) + v_ref(i+1);
    r_next = e(6) + r_ref(i+1);
    
    % Calculo das aceleracoes frontais e angulares  
    tau_u(i+1) = mu(4) + tau_u_r;
    tau_r(i+1) = mu(6) + tau_r_r;
    
    % Computa o vetor do ponto no proximo estado
    p = [x_next;y_next;psi_next;u_next;v_next;r_next];
end

% Plota o erro de x, y, psi, u, v e r
figure(1);
    lineWidth = 3;
    set(gcf, 'Position', get(0, 'Screensize'));
    fontSize = 14;
    graph1 = subplot(1,2,1);
        plot(t, errorVar(1,:),t, errorVar(2,:),t, errorVar(3,:),'linewidth',lineWidth);
        legend({'e_x(t)','e_y(t)','e_\psi(t)'},'FontSize',fontSize);
        title(graph1,{'Gr�fico dos Erros das Posi��es do ', 'HoverCraft em Rela��o � Refer�ncia'},'FontSize',fontSize);
        xlabel('t(s)','FontSize',fontSize);
        ylabel('Erro relativo � Posi��o','FontSize',fontSize);
        grid;
    graph2 = subplot(1,2,2);
        plot(t, errorVar(4,:),t,errorVar(5,:),t,errorVar(6,:),'linewidth',lineWidth);
        legend({'e_u(t)','e_v(t)','e_r(t)'},'FontSize',fontSize);
        title(graph2,{'Gr�fico dos Erros das Velocidades do' , 'HoverCraft em Rela��o � Refer�ncia'},'FontSize',fontSize);
        xlabel('t(s)','FontSize',fontSize);
        ylabel('Erro relativo � Velocidade','FontSize',fontSize);
        grid;
    pause(2.0);
    hold off;
    
% Faz o c�lculo da Din�mica do Hover dado uma fun��o de tau_u e outra de tau_r
% passa-se como refer�ncia o estado inicial do Hover
[x,y,psi,u,v,r] = DinamicaHoverEDOsRad(t,tau_u,tau_r,beta, p_initial);


figure(2);
    set(gcf, 'Position', get(0, 'Screensize'));
    plot(x_ref,y_ref,x,y,'linewidth',lineWidth);
    legend({'refer�ncia','hovercraft'},'FontSize',fontSize);
    title({'Trajet�ria de Refer�ncia ', 'e do HoverCraft'},'FontSize',fontSize);
    xlabel('x(m)','FontSize',fontSize);
    ylabel('y(m)','FontSize',fontSize);
    grid
    pause(2.0)
    hold off
    
% Imprime os gr�ficos de entrada e sa�da da din�mica do hover
figure(3);
    set(gcf, 'Position', get(0, 'Screensize'));
    HoverInOut(t,tau_u,tau_r,beta,x,y,psi,u,v,r, 12, 3);
    pause(2.0)
    hold off

% SImula o Hover
figure(4);
    set(gcf, 'Position', get(0, 'Screensize'));
    SimuladorHover(t,200,x, p_initial(1),y,p_initial(2),psi);  
    %pause(2.0)
    %hold off
    
function A = A_new(erro,traj_ref,beta)
    %C�lculo da matriz A
    if (erro(3) == 0)
        a1 =  - (traj_ref(4)*sin(traj_ref(3))+traj_ref(5)*cos(traj_ref(3)));
        a2 = (traj_ref(4)*cos(traj_ref(3))-traj_ref(5)*sin(traj_ref(3)));
    else
        a1 = ((cos(erro(3))-1) * (traj_ref(4)*cos(traj_ref(3))-traj_ref(5)*sin(traj_ref(3))) - (sin(erro(3))*(traj_ref(4)*sin(traj_ref(3))+traj_ref(5)*cos(traj_ref(3)))))/erro(3);
        a2 = ((cos(erro(3))-1) * (traj_ref(4)*sin(traj_ref(3))+traj_ref(5)*cos(traj_ref(3))) + (sin(erro(3))*(traj_ref(4)*cos(traj_ref(3))-traj_ref(5)*sin(traj_ref(3)))))/erro(3);
    end
    a3 = cos(erro(3)+traj_ref(3));
    a4 = sin(erro(3)+traj_ref(3));
    a5 = erro(6)+traj_ref(6);
    A = [0 0 a1 a3 -a4 0;0 0 a2 a4 a3 0;0 0 0 0 0 1;0 0 0 0 a5 traj_ref(5);0 0 0 -a5 -beta -traj_ref(4);0 0 0 0 0 0];
end


