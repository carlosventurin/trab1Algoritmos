%carregar a biblioteca simbólica
pkg load symbolic;

% Declararção da variável simbólica
syms y(x);

%1 - Solução analítica dos PVI

%Para o PVI a
eq1 = diff(y, x) == (x+y)/(x+1);
sol1 = dsolve(eq1, y(0) == 0);
%disp(sol1); TIRAR COMENTARIO

%Para o PVI b
eq2 = diff(y, x) == (2/x^2) - (3*y/x);
sol2 = dsolve(eq2, y(1) == 2);
%disp(sol2); TIRAR COMENTARIO

%2 - Conversão das soluções em funções não-simbólicas
s1 = matlabFunction(sol1);
s2 = matlabFunction(sol2);

%3 - Discretização da variável independente a partir de x0
n = 5;
h = 1/10;
dx = h/10;

%Para o PVI a
x0 = 0;
xdisc1 = x0:h:(x0 + n*h);
ydisc1 = s1(xdisc1);
xfino1 = x0:dx:(x0 + n*h);
yfino1 = s1(xfino1);

%Para o PVI b
x0 = 1;
xdisc2 = x0:h:(x0 + n*h);
ydisc2 = s2(xdisc2);
xfino2 = x0:dx:(x0 + n*h);
yfino2 = s2(xfino2);

%Gráficos

%PVI a
figure(1);
legenda = {};   % Inicializa célula que contém os rótulos dos objetos gráficos
hold on
plot(xfino1, yfino1, '-r', 'linewidth', 1);
legenda{end+1} = 'y(x)';    % Insere rótulo no final das células dos rótulos
xlabel('x, xn');
ylabel('y(xn), yn');
title("PVI: y'=(x+y)/(x+1), y(0)=0 \n Solução: y(x)=x*log(x + 1) - x + log(x + 1)")
legend(legenda, 'location', 'northeast');
hold off

%PVI b
figure(2);
legenda = {};   % Inicializa célula que contém os rótulos dos objetos gráficos
hold on
plot(xfino2, yfino2, '-r', 'linewidth', 1);
legenda{end+1} = 'y(x)';    % Insere rótulo no final das células dos rótulos
xlabel('x, xn');
ylabel('y(xn), yn');
title("PVI: y'=(2/x^2)-(3*y/x), y(1)=2 \n Solução: y(x)=(x^2+1)/3")
legend(legenda, 'location', 'northeast');
hold off

shg;














