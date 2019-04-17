%% Exemplo Hover
clear all; close all; clc;

t = 0:0.5:20;
tempo = t;

%Setando velocidades de surge, sway e yaw de entrada
u_in = 0*heaviside(tempo);
v_in = 2*heaviside(tempo);
r_in = 0*heaviside(tempo);
%v_in = A*cos(0.4*v_in_t);

%% Colocando o valores iniciais de posição
x0 = 0;
y0 = 0;
psi0 = 45;

opts = odeset('RelTol',1e-2,'AbsTol',1e-4);

[t,psi] = ode45(@(t,psi) myode3(t,psi,tempo,r_in), t, psi0, opts);

[t,x] = ode45(@(t,x) myode1(t,x,tempo,u_in,v_in,psi'), t, x0, opts);
[t,y] = ode45(@(t,y) myode2(t,y,tempo,u_in,v_in,psi'), t, y0, opts);


%% Plotando os gráficos de entrada e saída

figure(1)
set(gcf, 'Position', get(0, 'Screensize'));
    graph1 = subplot(1,2,1);
        graph1_1 = subplot(3,2,1);
            plot(t,u_in,'color','g','linewidth',3);
            grid
            title(graph1_1,'Entrada Velocidade de Surge','FontSize',12)
        graph1_2 = subplot(3,2,3);
            plot(t,v_in,'color','g','linewidth',3);
            grid
            title(graph1_2,'Entrada Velocidade de Sway','FontSize',12)
        graph1_4 = subplot(3,2,5);
            plot(t,r_in,'color','g','linewidth',3);
            grid
            title(graph1_4,'Entrada Velocidade angular de Yaw','FontSize',12)
            
    graph2 = subplot(1,2,2);
        hold on;
        view(3);
        lim = 100;
        grid on; box on; axis equal; axis([-lim lim -lim lim -25 25]);
        title(graph2,'Simulador do Hovercraft','FontSize',12)
        xlabel('X','FontSize',12)
        ylabel('Y','FontSize',12)
        zlabel('Z','FontSize',12)
        
        for i = 1:length(tempo)  
            %cla
            Cylinder([x(i),y(i),-5],[x(i),y(i),5],20,20,[0.3,0.3,0.3],1,0); 
            for j = 2:i  
                plot3([x(j) x(j-1)],[y(j) y(j-1)],[5 5],'r-','LineWidth',2);
            end
            pause(0.001);
        end
        

%% Função para resolução do X
function dxdt = myode1(t,x,tempo,u_in,v_in,psi)
    u_in = interp1(tempo,u_in,t);
    v_in = interp1(tempo,v_in,t);
    psi = interp1(tempo,psi,t);
    dxdt = u_in * cosd(psi) - v_in * sind(psi);
end

%% Função para resolução do Y
function dydt = myode2(t,y,tempo,u_in,v_in,psi)
    u_in = interp1(tempo,u_in,t);
    v_in = interp1(tempo,v_in,t);
    psi = interp1(tempo,psi,t);
    dydt = u_in * sind(psi) + v_in * cosd(psi);
end

%% Função para resolução do Y
function dpsidt = myode3(t,psi,tempo,r_in)
    r_in = interp1(tempo,r_in,t);
    dpsidt = r_in;
end
