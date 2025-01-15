function pviSol(func, edo, x0 ,y0, num)
    %Carregar a biblioteca simbólica
    pkg load symbolic;

    %Declararção da variável simbólica
    syms y(x);

    %Q1 - Solução analítica dos PVI
    sol = dsolve(edo, y(x0) == y0);
    printf("Solução analítica do PVI %g\n", num);
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

    %Cálculo dos Erros
    erroExato = abs(ydisc-ydisc);
    erroEuler = abs(ydisc-Yeuler);
    erroEulerMelhorado = abs(ydisc-YeulerMelhorado);
    erroEulerModificado = abs(ydisc-YeulerModificado);
    erroRungeKutta = abs(ydisc-YrungeKutta);
    erroDormandPrinceFixo = abs(ydisc-YdormandPrinceFixo);
    erroDormandPrinceAdap = abs(s(XdormandPrinceAdaptativo) - YdormandPrinceAdaptativo);
    
    %Matriz com os resultados de erros
    erroResultado = [xdisc', erroExato', erroEuler', erroEulerMelhorado', erroEulerModificado', erroRungeKutta', erroDormandPrinceFixo'];


    %Gráficos
    %Q5 - Pontos de cada método junto com a função verdadeira
    figure(num);
    legenda = {};   % Inicializa célula que contém os rótulos dos objetos gráficos
    hold on;

    plot(xfino, yfino, '-r', 'linewidth', 1);
    plot(xdisc, Yeuler, '-b|', 'linewidth', 1);
    plot(xdisc, YeulerMelhorado, '-co', 'linewidth', 1);
    plot(xdisc, YeulerModificado, '-y*', 'linewidth', 1);
    plot(xdisc, YrungeKutta, '-gd', 'linewidth', 1);
    plot(xdisc, YdormandPrinceFixo, '-kx', 'linewidth', 1);
    plot(XdormandPrinceAdaptativo, YdormandPrinceAdaptativo, '-ms', 'MarkerSize', 3, 'linewidth', 1);

    legenda = {'y(x)', 'Euler', 'Euler Melhorado', 'Euler Modificado', 'Runge-Kutta', 'ODE45 fixo', 'ODE45 adap'};
    xlabel('x, xn');
    ylabel('y(xn), yn');
    title(sprintf("Funcão verdadeira y(x) e valores aproximados\npelos métodos de solução para o PVI %d", num));
    legend(legenda, 'location', 'eastoutside');
    hold off;
    
    %Q6 - Gráfico de erros de cada método relativo à função verdadeira
    figure(num+2);
    hold on;
    warning('off', 'all');
    semilogy(xdisc, erroEuler, '-b|', 'linewidth', 1);
    semilogy(xdisc, erroEulerMelhorado, '-co', 'linewidth', 1);
    semilogy(xdisc, erroEulerModificado, '-y*', 'linewidth', 1);
    semilogy(xdisc, erroRungeKutta, '-gd', 'linewidth', 1);
    semilogy(xdisc, erroDormandPrinceFixo, '-kx', 'linewidth', 1);
    semilogy(XdormandPrinceAdaptativo, erroDormandPrinceAdap, '-ms', 'MarkerSize', 3, 'linewidth', 1);
    
    legenda = {'Euler', 'Euler Melhorado', 'Euler Modificado', 'Runge-Kutta', 'ODE45 fixo', 'ODE45 adap'};
    xlabel('x');
    ylabel('ln(Erro)');
    title(sprintf("Erros de cada método para o PVI %d", num));
    legend(legenda, 'location', 'eastoutside');
    shg;

    %Salva os gráficos
    pastaTabelas = 'graficos';
    if ~exist(pastaTabelas, 'dir')
        mkdir(pastaTabelas);
    end

    saveas(figure(num), fullfile(pastaTabelas, sprintf('graficoPvi%d.png', num))); % Salvar o primeiro gráfico
    saveas(figure(num+2), fullfile(pastaTabelas, sprintf('graficoErro%d.png', num))); % Salvar o segundo gráfico


    %Tabelas
    %Q7 - Tabela com os valores de cada método
    printf("Tabelas para o PVI %g\n", num);
    fprintf('%12s | %12s | %12s | %12s | %12s | %12s | %12s |\n', 'x', 'Valor Exato', 'Euler', 'Euler Mel.', 'Euler Mod.', 'R-G Gen3', 'ODE45 Fixo');
    fprintf('--------------------------------------------------------------------------------------------------------\n');
    fprintf('%12.6f | %12.6f | %12.6f | %12.6f | %12.6f | %12.6f | %12.6f |\n', resultado');
    
    %Q8 - Tabela com os erros de cada método
    disp('Erros')
    fprintf('%12.6f | %12.6e | %12.6e | %12.6e | %12.6e | %12.6e | %12.6e |\n', erroResultado');
    
    fprintf('---------------------------------------------------------------------------------------------------------------------------\n');

    %Salva as tabelas
    pastaTabelas = 'tabelas';
    if ~exist(pastaTabelas, 'dir')
        mkdir(pastaTabelas);
    end

    arquivoTabelas = fullfile(pastaTabelas, sprintf('tabelasPvi%d.txt', num));
    fileID = fopen(arquivoTabelas, 'w');

    fprintf(fileID, "Tabelas para o PVI %g\n", num);
    fprintf(fileID, '%12s | %12s | %12s | %12s | %12s | %12s | %12s |\n', 'x', 'Valor Exato', 'Euler', 'Euler Mel.', 'Euler Mod.', 'R-G Gen3', 'ODE45 Fixo');
    fprintf(fileID, '--------------------------------------------------------------------------------------------------------\n');
    fprintf(fileID, '%12.6f | %12.6f | %12.6f | %12.6f | %12.6f | %12.6f | %12.6f |\n', resultado');

    fprintf(fileID, '\nErros\n');
    fprintf(fileID, '%12.6f | %12.6e | %12.6e | %12.6e | %12.6e | %12.6e | %12.6e |\n', erroResultado');
    fprintf(fileID, '---------------------------------------------------------------------------------------------------------------------------\n');

    fclose(fileID);
    
end