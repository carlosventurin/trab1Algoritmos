function prob1()
    %carregar a biblioteca simbólica
    pkg load symbolic;

    % Declararção da variável simbólica
    syms y(x);

    %Cálculos da equação 1
    eq1 = diff(y, x) == (x+y)/(x+1);
    x0 = 0;
    y0 = 0;
    num = 1;
    pviSol(eq1 , x0, y0, num);

    %Cálculos da equação 2
    eq2 = diff(y, x) == (2/x^2) - (3*y/x);
    x0 = 1;
    y0 = 2;
    num = 2;
    pviSol(eq2, x0, y0, num);
end
