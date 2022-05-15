exec("TP1_TIM.sci");

te = 0.000001
fe = 1/te

for i = 1:N*k,
    Tet(i)=te*i;
end

M = message(N);
nr = nrz(M);
bip =  nrz_bip(M);
man =  manchester(M);

F = [0:(N*k-1)]*fe/(N*k);
Mtfft_nrz = 20*log10(abs(fft(nr,-1)))
Mtfft_bip = 20*log10(abs(fft(bip,-1)))
Mtfft_man = 20*log10(abs(fft(man,-1)))
/*
subplot(3,1,1);
plot(F, Mtfft_nrz);
xtitle("Info codée nrz")

subplot(3,1,2);
plot(F, Mtfft_bip)
xtitle("Info codée bip")

subplot(3,1,3);
plot(F, Mtfft_man)
xtitle("Codage Manchester")
*/

/*
filtre = filtrage_nrz(Mtfft_nrz);
subplot(2, 1, 2);
plot(F, filtre);
xtitle("FFT NRZ filtrée");

subplot(2, 1, 1);
plot(F, Mtfft_nrz);
xtitle("FFT NRZ non filtrée");
*/
Mtfftcalc = fft(nr, -1);
[filtre] = idfilter(F, Mtfftcalc);

sig = 0.035;
noise = sig*rand(Tet,"normal");
scf();
Signaltemp = ifft(filtre)+noise;
//plot(Tet, Signaltemp);
//xtitle("Signal + bruit")



subplot(2, 1, 1)
plot(Tet, nr);
xtitle("Signal en entrée");

subplot(2, 1, 2)
[result] = decision(Signaltemp);
plot(Tet, nrz(result));
xtitle("Signal recomposé");



tauxError(M, result)



