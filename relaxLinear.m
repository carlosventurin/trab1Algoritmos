function relaxLinear(t0, v0)
    syms v(t);

    r = 5e-4;
    roAgua = 1000;
    rof = 1.225;
    g = 9.81;
    mi = 17.2e-6;

    V = 4/3*pi*r^3;
    me = V*roAgua;
    mf = V*rof;
    
    func = @(t, v) g*(1 - mf/me) - 6*pi*mi*r*v/me;
    edo = diff(v, t) == g*(1 - mf/me) - 6*pi*mi*r*v/me;
    disp('------------------------------------------------------------------------------------------------------------------------------------')
    
    %Q1 - Cálculo da velocidade final
    vFinal = g*(me - mf)/(6*pi*mi*r);
    
    %Q3 - Solução analítica dos PVI

    %{
    sol = dsolve(edo, y(x0) == y0);
    disp(sol);

    %Q2 - Conversão das soluções em funções não-simbólicas
    s = matlabFunction(sol);

    %Q3 - Discretização da variável independente a partir de x0
    n = 5;
    h = 1/10;
    dx = h/10;

    xdisc = x0:h:(x0 + n*h);
    ydisc = s(xdisc);
    xfino = x0:dx:(x0 + n*h);
    yfino = s(xfino);
    %}

    %Gráficos
    figure(5);
    legenda = {};   % Inicializa célula que contém os rótulos dos objetos gráficos
    hold on;

    plot([0 25], [vFinal vFinal]);

    %{
    legenda = {'y(x)'};
    xlabel('x, xn');
    ylabel('y(xn), yn');
    title("PVI: y'=(x+y)/(x+1), y(0)=0 \n Solução: y(x)=x*log(x + 1) - x + log(x + 1)");
    legend(legenda, 'location', 'northeast');
    hold off;
    %}
   
end