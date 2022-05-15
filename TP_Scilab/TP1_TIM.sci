clear;
close;
clc;
N = 1000;
k = 10;
V = 5
function[M] = message(N)
    M = [1:1:N];
    for I = [1:N]
        if rand(1) <= 0.5
            M(I) = 0;
        else M(I) = 1;
        end
    end
endfunction

function [Mt] = nrz(M, N)

    c = 0;
    for i = 1:N,
        if M(i) == 1
            for j=c+1:c+k,
                Mt(j) = 1;
            end
        else
            for j=c+1:c+k,
                Mt(j) = 0;
            end
        end
    c = c+k;
    end
endfunction

function[Mt] = nrz_bip(M, N, V)

c = 0;
    for i = 1:N,
        if M(i) == 1
            for j=c+1:c+k,
                Mt(j) = V;
            end
        else
            for j=c+1:c+k,
                Mt(j) = -V;
            end
        end
    c = c+k;
    end
endfunction

function[Mt] = manchester(M, N)

c = 0;
    for i = 1:N,
        if M(i) == 1
            for j=c+1:c+k/2,
                Mt(j) = V;
            end
            for j=c+k/2+1:c+k,
                Mt(j) = -V;
            end
        else
            for j=c+1:c+k/2,
                Mt(j) = -V;
            end
            for j=c+k/2+1:c+k,
                Mt(j) = V;
            end
        end
    c = c+k;
    end
endfunction

function[Mt]=filtrage_nrz(M)
    for j=[1:length(M)],
        Mt(j) = 0;
    end
    i = 1;
    while M(i) > 0,
       Mt(i) = M(i);
       i = i+1; 
    end
endfunction

function[filtre] = idfilter(F, Mat)
    fc = 100000;
    for i = 1:k*N,
        if F(i)<fc
            filtre(i) =Mat(i);
        else
            filtre(i) = 0;
        end
    end
endfunction

function [res] = decision(signal)
    i = 1;
    moy = 0;
    for j = 1:k*N,
       moy = moy + abs(signal(j));
       if modulo(j, 10) == 0
           if moy/10 > 0.5
            res(i) = 1;
            else
            res(i) = 0;
           end
            moy = 0;
            i = i+1;
       end
    end
endfunction

function [teb] = tauxError(M, Mt)
    teb = 0;
    for i = [1:N]
        if M(i) ~= Mt(i)
            teb = teb +1;
        end
    end
    teb = teb/N
endfunction


