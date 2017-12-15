clear all
close all
clc
load('30agos2016BBZ.mat');

%%% Los datos inician a las 9 de la noche, por lo que resulta mejor tomar
%%% los datos desde las 10 de la noche
tnew=(BB30(:,1)>=7.365729166666666*10^5);
cat2=BB30(tnew>0,:);

%construir vectores de tiempo y datos
t=cat2(:,1);
t=datevec(t);
dt=(t(2,6));
sps=1/dt;
t=[0:dt:(length(t)-1)*dt]'*(1/3600);
time=length(t)*dt;

x=cat2(:,2);

%x=BB30(:,2);

%NO HAY VALORES NULOS
NA=find(isnan(x));

%se hace el cambio a componentes físicas
%sensitivity  1m/s= 3.01719e8 cuentas
x=x*(1/(3.01719*10^8));
x=x*10^3;

[d]=bandpass(x,1,45,dt);
figure (1)
plot(t,d)
title("senal original banda ancha")
xlabel("tiempo (hr)")
ylabel("velocidad (mm/s)")

[Pxx,Fx] = spectrum2(d,sps);

figure(2)
plot(Fx, Pxx,'r')
%podemos escoger cual es el límite en Y en el cual queremos que nos
%grafique.
title('espectro de frecuencias')
xlabel('frecuencia (Hz)')
ylabel('mm^2/s')

figure(3)
%FUNCTION SPECTROGRAM
%con la función spectrogram se puede realizar el espectrograma de la
%figura, donde x representa el vector de amplitud, 2024 es el tamaño de
%ventana, 1012, es el traslape, 2024 el num de datos a los cuales se les
%realiza la transformada de Fourier, 100 es el sps. 
%spectrogram(data,sizewindow,nslap,nfft,fs o sps)
spectrogram(d,1500,750,1500,sps,'yaxis');

