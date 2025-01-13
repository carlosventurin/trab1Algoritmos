function relaxLinear(t0, v0)
    syms v(t); %r roAgua rof g mi V me mf p;

    r = sym(5)/10000; %5e-4 
    roAgua = 1000;
    rof = sym(1225)/1000; %1.225 
    g =  sym(981)/100; %9.81
    mi = sym(172)/10000000; %17.2e-6 
    p = sym(pi);

    V = sym(4)/3*p*r^3;
    me = V*roAgua;
    mf = V*rof;
    
    func = @(t, v) double(g * (1 - mf / me)) - 6 * double(p * mi * r / me) * v;
    edo = diff(v, t) == g*(1 - mf/me) - 6*p*mi*r*v/me;
    
    %Q1 - Cálculo da velocidade final
    vFinal = g*(me - mf)/(6*p*mi*r);
    vFinalNum = double(vFinal);
    
    %Q3 - Solução analítica do PVI
    sol = dsolve(edo, v(t0) == v0);

    %Q4 - Evolução da velocidade
    s = matlabFunction(sol);

    n = 50;
    h = 5/10;
    dt = h/10;

    tdisc = t0:h:(t0 + n*h);
    vdisc = s(tdisc);
    tfino = t0:dt:(t0 + n*h);
    vfino = s(tfino);

    %Q5 - Sequência dos valores aproximados pelo método de Euler
    [tEuler, vEuler] = euler(func, t0, v0, h, n);
    

    figure(5);
    legenda = {};   % Inicializa célula que contém os rótulos dos objetos gráficos
    hold on;
    %Q2 - Desenho da velocidade final como reta horizontal assintótica no gráfico
    plot([0 25], [vFinalNum vFinalNum],  '--r', 'linewidth', 1);
    %Q4 - Desenho da evoluçao da velocidade
    plot(tfino, vfino, '-r', 'linewidth', 1);
    %Q5 - Desenho dos valores aproximados pelo método de Euler
    plot(tEuler, vEuler, 'bx');


    legenda = {'vinf para relaxação linear', 'Re << 1:v(0) = 0.00', 'Euler relaxação linear'};
    xlabel('t [s]');
    ylabel('v [m/s]');
    title("Relaxação de velocidade com força de arrasto");
    legend(legenda, 'location', 'southeast');
    hold off;
    shg;


    
end