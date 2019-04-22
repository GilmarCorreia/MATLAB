%% Din�mica do Hover

% essa fun��o calcula a din�mica do hover, dado uma fun��o de tau_u e tau_r
% v�lida durante um intervalo t, e uma constante beta, pr�pria do
% amortecimento do sistema. Os resultados s�o disponibilizados em um vetor
% com as fun��es de sa�da de x, y, psi, u, v e r. Dado as condi��es
% iniciais em um vetor de initialCond = [x0,y0,psi0,u0,v0,r0]

function [x,y,psi,u,v,r] = DinamicaHoverEDOsGraus(t,tau_u,tau_r,beta, initialCond)
    opts = odeset('RelTol',1e-2,'AbsTol',1e-4);

    [ts,s] = ode45(@(ts,s) odeHover(ts,s,tau_u,t,tau_r,beta), t, initialCond,opts);
    
    x = s(:,1);
    y = s(:,2);
    psi = s(:,3);
    u = s(:,4);
    v = s(:,5);
    r = s(:,6);
end

%% Como resolver as EDOs

function dsdt = odeHover(ts,s,tau_u, tempo,tau_r,beta)

    tau_u = interp1(tempo,tau_u,ts); 
    tau_r = interp1(tempo,tau_r,ts);
    
    dsdt = [s(4) * cosd(s(3)) - s(5) * sind(s(3));
            s(4) * sind(s(3)) + s(5) * cosd(s(3));
            s(6);
            ((s(5)*s(6)) + tau_u); 
            (-(s(4)*s(6)) - (beta*s(5)));
            tau_r];
end
