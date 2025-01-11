function [X, Y] = dormandPrince(f, x0, y0, h, n, fixo)
    %Definição do ponto final de integração
    xn = x0 + n*h;
    
    %Cálculo de Dormand-Prince com passo fixo
    if fixo == 1 
        x = (x0:h:xn)';
        [X, Y] = ode45(f, x, [y0]);
    
    %Cálculo de Dormand-Prince com passo adaptativo
    else 
        [X, Y] = ode45(f, [x0,xn], [y0]);
    end

    X = X';
    Y = Y';
end