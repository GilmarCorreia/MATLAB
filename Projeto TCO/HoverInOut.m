%% Função dos Gráficos de Entrada e Saída do HoverCraft
function HoverInOut(t,tau_u,tau_r,beta,x,y,psi,u,v,r, fontSize, lineWidth)
    set(gcf, 'Position', get(0, 'Screensize'));
    graph1_1 = subplot(6,2,[1 3]');
        plot(t,tau_u,'color','g','linewidth',lineWidth);
        set(gca,'xticklabel',{[]});
        ylabel('aceleração frontal (m/s^2)','FontSize',fontSize);
        grid;
        title(graph1_1,'\tau_u','FontSize',fontSize)
    graph1_2 = subplot(6,2,[5 7]');
        plot(t,tau_r,'color','g','linewidth',lineWidth);
        set(gca,'xticklabel',{[]})
        ylabel('aceleração lateral (m/s^2)','FontSize',fontSize);
        grid;
        title(graph1_2,'\tau_r','FontSize',fontSize)
    graph1_3 = subplot(6,2,[9 11]');
        plot(t,beta*ones(1,length(t)),'color','g','linewidth',lineWidth);
        xlabel('t(s)','FontSize',fontSize);
        ylabel('amortecimento (1/s)','FontSize',fontSize);
        grid;
        title(graph1_3,'\beta','FontSize',fontSize)

    graph2_1 = subplot(6,2,2);
        plot(t,x,'color','r','linewidth',lineWidth);
        set(gca,'xticklabel',{[]})
        ylabel('posição x (m)','FontSize',fontSize);
        grid;
        title(graph2_1,'Posição X','FontSize',fontSize);
    graph2_2 = subplot(6,2,4);
        plot(t,y,'color','r','linewidth',lineWidth);
        set(gca,'xticklabel',{[]})
        ylabel('posição y (m)','FontSize',fontSize);
        grid;
        title(graph2_2,'Posição Y','FontSize',fontSize);
    graph2_3 = subplot(6,2,6);
        plot(t,psi,'color','r','linewidth',lineWidth);
        set(gca,'xticklabel',{[]})
        ylabel('\psi (rad ou °)','FontSize',fontSize);
        grid;
        title(graph2_3,'Ângulo \psi','FontSize',fontSize);
    graph2_4 = subplot(6,2,8);
        plot(t,u,'color','r','linewidth',lineWidth);
        set(gca,'xticklabel',{[]})
        ylabel('u (m/s)','FontSize',fontSize);
        grid;
        title(graph2_4,'Velocidade de Surge','FontSize',fontSize);
    graph2_5 = subplot(6,2,10);
        plot(t,v,'color','r','linewidth',lineWidth);
        set(gca,'xticklabel',{[]})
        ylabel('v (m/s)','FontSize',fontSize);
        grid;
        title(graph2_5,'Velocidade de Sway','FontSize',fontSize);
    graph2_6 = subplot(6,2,12);
        plot(t,r,'color','r','linewidth',lineWidth);
        xlabel('t(s)','FontSize',fontSize);
        ylabel('r (rad/s)','FontSize',fontSize);
        grid;
        title(graph2_6,'Velocidade angular de Yaw','FontSize',fontSize);     
end