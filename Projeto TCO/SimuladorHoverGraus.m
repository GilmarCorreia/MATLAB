function SimuladorHoverGraus(t,lim,x,x0,y,y0,psi)
    
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
    for i = 1:length(t)
        cla;
        Cylinder([y(i),x(i),-5],[y(i),x(i),5],20,20,[0.3,0.3,0.3],1,0);
        Cylinder([y(i),x(i),0],[y(i)+(comp*sind(psi(i))),x(i)+(comp*cosd(psi(i))),0],2,20,[1,0,0],1,0);
        Cylinder([y(i),x(i),0],[y(i)+(comp*cosd(psi(i))),x(i)-(comp*sind(psi(i))),0],2,20,[0,1,0],1,0);
        Cylinder([y(i),x(i),0],[y(i),x(i),comp],2,20,[0,0,1],1,0);
        delete(findall(gcf,'type','annotation'));
        a = annotation('textbox', [0.75, 0.1, 0.1, 0.1], 'String', {"x = " + x(i),"y = " + y(i),"\psi = " + psi(i)});        
        a.FontSize = 12;
        for j = 2:i  
            plot3([y(j) y(j-1)],[x(j) x(j-1)],[-5 -5],'r-','LineWidth',2)
        end
        pause(0.005);
        
    end
    
    
end