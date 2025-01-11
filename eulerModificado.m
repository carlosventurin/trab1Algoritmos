function [X,Y] = eulerModificado(f, x0, y0, h, n)
    %Inicialização dos vetores
    X = zeros(1,n+1);
    Y = zeros(1,n+1);

    %Inicialização das variáveis x e y
    x = x0;
    y = y0;

    %Adição dos valores iniciais nos vetores
    X(1) = x0;
    Y(1) = y0;

    h2 = h/2.0;

    for i=2:n+1
        y = y + h*f(x+h2, y+h2*f(x,y));
        x = x + h;
        X(i) = x; Y(i) = y;
    end
end