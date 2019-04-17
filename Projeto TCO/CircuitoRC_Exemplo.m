%% EXEMPLO DE RESOLUÇÃO DE UM SISTEMA DE UM CIRCUITO RC

R = 2.5;
C = 1;

t = -5:0.1:30;


% Setando tensão de entrada
v_in_t = t;
A = 5; % amplitude
v_in = A*heaviside(v_in_t);
%v_in = A*cos(0.4*v_in_t);

% Colocando o V inicial do Capacitor
v0 = 0;

opts = odeset('RelTol',1e-2,'AbsTol',1e-4);
[t,v] = ode45(@(t,v) myode(t,v,v_in_t,v_in,R,C), t, v0, opts);

% Plotando os gráficos de entrada e saída
figure(1)
graph1 = subplot(1,2,1);
plot(t,v_in,'color','g','linewidth',3);
ylim([-(A+3) (A+3)])
grid
title(graph1,'Entrada','FontSize',12)

graph2 = subplot(1,2,2);
plot(t,v,'color','r','linewidth',3);
ylim([-(A+3) (A+3)])
grid
title(graph2,'Saida','FontSize',12)

% Função para EDO
function dvdt = myode(t,v,v_in_t,v_in,R,C)
    v_in = interp1(v_in_t,v_in,t);
    dvdt = (1/(R*C))*(v_in-v); 
end
