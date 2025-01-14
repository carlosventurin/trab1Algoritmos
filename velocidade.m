function [tfino, vfino, tEuler, vEuler] = velocidade(t0, v0, func, analit, relax)
    syms v(t);

    %Q3 - Solução analítica do PVI
    if relax
        sol = dsolve(analit, v(t0) == v0);
        s = matlabFunction(sol);
    else
        s = analit;
    end

    %Q4 - Evolução da velocidade

    n = 50;
    h = 5/10;
    dt = h/10;

    tdisc = t0:h:(t0 + n*h);
    vdisc = s(tdisc);

    if relax
        tfino = t0:dt:(t0 + n*h);
        vfino = s(tfino);
    else 
        tfino = t0:dt:(t0 + n*h);
        vfino = arrayfun(s, tfino);
    end

    %Q5 - Sequência dos valores aproximados pelo método de Euler
    [tEuler, vEuler] = euler(func, t0, v0, h, n);
    
end