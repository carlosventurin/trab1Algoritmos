function pviSol(func, edo, x0 ,y0, num)
    %carregar a biblioteca simbólica
    pkg load symbolic;

    % Declararção da variável simbólica
    syms y(x);

    %Q1 - Solução analítica dos PVI
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

    %Q4 - Aproximações da solução analítica
    [X, Yeuler] = euler(func, x0, y0, h, n); %Método de Euler
    [X, YeulerMelhorado] = eulerMelhorado(func, x0, y0, h, n); %Método de Euler Melhorado
    [X, YeulerModificado] = eulerModificado(func, x0, y0, h, n); %Método de Euler Modificado
    [X, YrungeKutta] = rungeKutta(func, x0, y0, h, n); %Método de Runge-Kutta
    [X, YdormandPrinceFixo] = dormandPrince(func, x0, y0, h, n, 1); %Método de Dormand-Prince com passo Fixo
    [XdormandPrinceAdaptativo, YdormandPrinceAdaptativo] = dormandPrince(func, x0, y0, h, n, 0); %Método de Dormand-Prince com passo Adaptativo

    %Matriz com os resultados
    resultado = [xdisc', ydisc', Yeuler', YeulerMelhorado', YeulerModificado', YrungeKutta', YdormandPrinceFixo'];

    %{ 
    %TIRAR COMENTARIO -----------------------------------------------------------
    
    %Tabelas
    %Q7 - Tabela com os valores de cada método
    fprintf('%11s | %11s | %11s | %11s | %11s | %11s | %11s |\n', 'x', 'Valor Exato', 'Euler', 'Euler Mel.', 'Euler Mod.', 'R-G Gen3', 'ODE45 Fixo');
    fprintf('-------------------------------------------------------------------------------------------------\n');
    fprintf('%11.6f | %11.6f | %11.6f | %11.6f | %11.6f | %11.6f | %11.6f |\n', resultado')
    
    %}

    %Gráficos
    
    figure(num);
    legenda = {};   % Inicializa célula que contém os rótulos dos objetos gráficos
    hold on;

    plot(xfino, yfino, '-r', 'linewidth', 1);
    plot(xdisc, Yeuler, '-b', 'linewidth', 1);
    plot(xdisc, Yeuler, 'o')
    plot(xdisc, YeulerMelhorado, '-c', 'linewidth', 1);
    plot(xdisc, YeulerModificado, '-y', 'linewidth', 1);
    plot(xdisc, YrungeKutta, '-g', 'linewidth', 1);
    plot(xdisc, YdormandPrinceFixo, '-k', 'linewidth', 1);
    plot(XdormandPrinceAdaptativo, YdormandPrinceAdaptativo, '-m', 'linewidth', 1);

    legenda = {'y(x)', 'Euler', 'Euler Melhorado', 'Euler Modificado', 'Runge-Kutta', 'ODE45 fixo', 'ODE45 adap'};
    xlabel('x, xn');
    ylabel('y(xn), yn');
    title("PVI: y'=(x+y)/(x+1), y(0)=0 \n Solução: y(x)=x*log(x + 1) - x + log(x + 1)");
    legend(legenda, 'location', 'northeast');
    hold off;
    shg;
    
end
