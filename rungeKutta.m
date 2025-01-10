function [X,Y] = rungeKutta(f, x0, y0, h, n)
    %Inicialização dos vetores
    X = zeros(1,n+1);
    Y = zeros(1,n+1);

    %Inicialização das variáveis x e y
    x = x0;
    y = y0;

    %Adição dos valores iniciais nos vetores
    X(1) = x0;
    Y(1) = y0;

    %Parâmetros específicos do método
    alfa = 1/2;
    beta = 1/6;

    for i = 2:n+1
        % Cálculo dos coeficientes
        coef1 = f(x, y);
        coef2 = f(x + alfa*h, y + alfa*h*coef1);
        coef3 = f(x + h, y - h*coef1 + 2*h*coef2);

        X(i) = x + h;
        Y(i) = y + h * (beta*coef1 + 4*beta*coef2 + beta*coef3);

        x = X(i);
        y = Y(i);
    end
end