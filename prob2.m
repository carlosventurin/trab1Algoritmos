function prob2()
    syms v(t);

    r = sym(5)/10000; %5e-4 
    roAgua = 1000;
    rof = sym(1225)/1000; %1.225 
    g =  sym(981)/100; %9.81
    mi = sym(172)/10000000; %17.2e-6 
    p = sym(pi);
    Cd = sym(4)/1000;

    n = 50;
    h = 5/10;
    dt = h/2;

    A = p*r^2;
    V = sym(4)/3*p*r^3;
    me = V*roAgua;
    mf = V*rof;
    alfa = Cd*rof*A/(2*me);

    %Relaxação Linear
    t0 = 0;
    v0 = 0;

    %Q1 - Cálculo da velocidade final
    vFinalLin = g*(me - mf)/(6*p*mi*r);
    vFinalLinNum = double(vFinalLin);
    
    func = @(t, v) double(g * (1 - mf / me)) - 6 * double(p * mi * r / me) * v;
    edo = diff(v, t) == g*(1 - mf/me) - 6*p*mi*r*v/me;

    %Q3 - Solução analítica do PVI
    solLin = dsolve(edo, v(t0) == v0);
    sLin = matlabFunction(solLin);
    
    %Q4 - Evolução da velocidade
    tfinoLin = t0:dt:(t0 + n*h);
    vfinoLin = sLin(tfinoLin);

    %Q5 - Sequência dos valores aproximados pelo método de Euler
    [tEulerLin, vEulerLin] = euler(func, t0, v0, h, n);


    %Relaxação Não Linear
    v0 = 60;

    %Q1 - Cálculo da velocidade final
    vFinalNao = sqrt(g*(1 - mf/me) / alfa);
    vFinalNaoNum = double(vFinalNao);

    func2 = @(t, v) double(g * (1 - mf / me)) - double(Cd*rof*A/(2*me)) * v^2;
    eqNao = @(t) vFinalNaoNum * ((v0 + vFinalNaoNum) + (v0 - vFinalNaoNum).*exp(-2*double(alfa)*vFinalNaoNum.*t)) ./ ((v0 + vFinalNaoNum) - (v0 - vFinalNaoNum).*exp(-2*double(alfa)*vFinalNaoNum.*t));

    %Q4 - Evolução da velocidade
    tNao = linspace(t0, (t0 + n*h), 500);
    vNao = eqNao(tNao);

    %Q5 - Sequência dos valores aproximados pelo método de Euler
    [tEulerNao, vEulerNao] = euler(func2, t0, v0, h, n);


    %Gráfico
    figure(5);
    legenda = {};   % Inicializa célula que contém os rótulos dos objetos gráficos
    hold on;

    %Relaxação Linear
    %Q2 - Desenho da velocidade final como reta horizontal assintótica no gráfico
    plot([0 25], [vFinalLinNum vFinalLinNum],  '--r', 'linewidth', 1);

    %Q4 - Desenho da evoluçao da velocidade
    plot(tfinoLin, vfinoLin, '-r', 'linewidth', 1);

    %Q5 - Desenho dos valores aproximados pelo método de Euler
    plot(tEulerLin, vEulerLin, 'bx');

    %Relaxação Não Linear
    %Q2 - Desenho da velocidade final como reta horizontal assintótica no gráfico
    plot([0 25], [vFinalNaoNum vFinalNaoNum],  '--m', 'linewidth', 1);

    %Q4 - Desenho da evoluçao da velocidade
    plot(tNao, vNao, '-g', 'linewidth', 1);

    %Q5 - Desenho dos valores aproximados pelo método de Euler
    plot(tEulerNao, vEulerNao, 'bx');

    legenda = {'vinf para relaxação linear', 'Re << 1:v(0) = 0.00', 'Euler relaxação linear', 'vinf para relaxação não linear', 'Re >> 1:v(0) = 60.00', 'Euler relaxação não linear'};
    xlabel('t [s]');
    ylabel('v [m/s]');
    title("Relaxação de velocidade com força de arrasto");
    legend(legenda, 'location', 'southeast');
    hold off;
    shg;

end