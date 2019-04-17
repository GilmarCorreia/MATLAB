%% Exemplo Hover
clear all; close all; clc;

t = 0:0.5:20;
tempo = t;

%Setando aceleração frontal e angular
tau_u = 1*heaviside(tempo);
tau_r = 0*heaviside(tempo);
beta = 1.2;
%v_in = A*cos(0.4*v_in_t);

%% Colocando o valores iniciais de posição
x0 = 0;
y0 = 0;
psi0 = 0;
u0 = 0;
v0 = 0;
r0 = 0;

opts = odeset('RelTol',1e-2,'AbsTol',1e-4);

[t,r] = ode45(@(t,r) myode6(t,r,tempo,tau_r), t, r0, opts);
[t,psi] = ode45(@(t,psi) myode3(t,psi,tempo,r'), t, psi0, opts);

[t,s] = ode45(@(t,s) myode4(t,s,tempo,r',tau_u,beta), t, [u0 v0], opts);
[t,y] = ode45(@(t,y) myode2(t,y,tempo,s(:,1)',s(:,2)',psi'), t, y0, opts);
[t,x] = ode45(@(t,x) myode1(t,x,tempo,s(:,1)',s(:,2)',psi'), t, x0, opts);



%% Plotando os gráficos de entrada e saída

figure(1);
    in_out(t,tau_u,tau_r,beta,x,y,psi,s,r, 12, 3);
    
figure(2);
    Simulador(t,200,x,x0,y,y0,psi);    
    
%% Como resolver as EDOs

% Função para resolução do X
function dxdt = myode1(t,x,tempo,u_in,v_in,psi)
    u_in = interp1(tempo,u_in,t);
    v_in = interp1(tempo,v_in,t);
    psi = interp1(tempo,psi,t);
    dxdt = u_in * cosd(psi) - v_in * sind(psi);
end

% Função para resolução do Y
function dydt = myode2(t,y,tempo,u_in,v_in,psi)
    u_in = interp1(tempo,u_in,t);
    v_in = interp1(tempo,v_in,t);
    psi = interp1(tempo,psi,t);
    dydt = u_in * sind(psi) + v_in * cosd(psi);
end

% Função para resolução do psi
function dpsidt = myode3(t,psi,tempo,r_in)
    r_in = interp1(tempo,r_in,t);
    dpsidt = r_in;
end

% Função para resolução do u e v
function dsdt = myode4(t,s,tempo,r,tau_u,beta)
    r = interp1(tempo,r,t);
    tau_u = interp1(tempo,tau_u,t);
    dsdt = [s(2)*r + tau_u; -s(1)*r - beta*s(2)];
end

% Função para resolução do r
function drdt = myode6(t,r,tempo,tau_r)
    tau_r = interp1(tempo,tau_r,t);
    drdt = tau_r;
end

%% Função dos Gráficos do HoverCraft e Simulador
function in_out(t,tau_u,tau_r,beta,x,y,psi,s,r, fontSize, lineWidth)
    set(gcf, 'Position', get(0, 'Screensize'));
    graph1_1 = subplot(6,2,[1 3]');
        plot(t,tau_u,'color','g','linewidth',lineWidth);
        grid;
        title(graph1_1,'TAU_U','FontSize',fontSize)
    graph1_2 = subplot(6,2,[5 7]');
        plot(t,tau_r,'color','g','linewidth',lineWidth);
        grid;
        title(graph1_2,'TAU_R','FontSize',fontSize)
    graph1_3 = subplot(6,2,[9 11]');
        plot(t,beta*ones(1,length(t)),'color','g','linewidth',lineWidth);
        %plot(t,beta,'color','g','linewidth',lineWidth);
        grid;
        title(graph1_3,'Beta','FontSize',fontSize)

    graph2_1 = subplot(6,2,2);
        plot(t,x,'color','g','linewidth',lineWidth);
        grid;
        title(graph2_1,'Posição X','FontSize',fontSize);
    graph2_2 = subplot(6,2,4);
        plot(t,y,'color','g','linewidth',lineWidth);
        grid;
        title(graph2_2,'Posição Y','FontSize',fontSize);
    graph2_3 = subplot(6,2,6);
        plot(t,psi,'color','g','linewidth',lineWidth);
        grid;
        title(graph2_3,'Ângulo PSI','FontSize',fontSize);
    graph2_4 = subplot(6,2,8);
        plot(t,s(:,1),'color','g','linewidth',lineWidth);
        grid;
        title(graph2_4,'Velocidade de Surge','FontSize',fontSize);
    graph2_5 = subplot(6,2,10);
        plot(t,s(:,2),'color','g','linewidth',lineWidth);
        grid;
        title(graph2_5,'Velocidade de Sway','FontSize',fontSize);
    graph2_6 = subplot(6,2,12);
        plot(t,r,'color','g','linewidth',lineWidth);
        grid;
        title(graph2_6,'Velocidade angular de Yaw','FontSize',fontSize);     
    pause(1.0);
end

function Simulador(t,lim,x,x0,y,y0,psi)
    
    set(gcf, 'Position', get(0, 'Screensize'));
    % INVERTENDO OS EIXOS DE POSIÇÃO
    set(gca, 'XDir', 'reverse');
    set(gca, 'YDir', 'reverse');
    set(gca, 'ZDir', 'reverse');
    
    hold on;

    view(3);
   
    grid on; box on; axis equal; axis([y0-lim y0+lim x0-lim x0+lim -50 50]);
    title('Simulador do Hovercraft','FontSize',12);
    xlabel('Y','FontSize',12);
    ylabel('X','FontSize',12);
    zlabel('Z','FontSize',12);
    comp = 30;
    for i = 1:5:length(t)
        cla;
        Cylinder([y(i),x(i),-5],[y(i),x(i),5],20,20,[0.3,0.3,0.3],1,0);
        Cylinder([y(i),x(i),0],[y(i)+(comp*sind(psi(i))),x(i)+(comp*cosd(psi(i))),0],2,20,[1,0,0],1,0);
        Cylinder([y(i),x(i),0],[y(i)+(comp*cosd(psi(i))),x(i)-(comp*sind(psi(i))),0],2,20,[0,1,0],1,0);
        Cylinder([y(i),x(i),0],[y(i),x(i),comp],2,20,[0,0,1],1,0);

        for j = 2:5:i  
            plot3([y(j) y(j-1)],[x(j) x(j-1)],[-5 -5],'r-','LineWidth',2)
        end
        pause(0.001);
    end
end
