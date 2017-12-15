clear all
close all
clc
load('30agos2016ACZ.mat');
t=ACZ30(:,1);
t=datevec(t);
dt=(t(2,6));
sps=1/dt;
t=[0:dt:(length(t)-1)*dt]'*(1/3600);
time=length(t)*dt; %tiempo en horas 

%el evento inicio a las 10 de la noche del 30 de agosto

x=ACZ30(:,2);

%NO HAY VALORES NULOS
NA=find(isnan(x));

%se convierte a unidades físicas
% 1 cuenta= 2.04x10^-5 m/s^2
x=x*(1/2.04*10^-5);

%se crea un pasaaltos con la función banpass
[d]=bandpass(x,0.2,80,dt);
figure (1)
plot(t,d)
title("senal original acelerómetro")
xlabel("tiempo (hr)")
ylabel("aceleración (m/s2)")

%%% se construye el espectro de frecuencias
[Pxx,Fx] = spectrum2(d,sps);

figure(2)
plot(Fx,Pxx,'r')
title('espectro de frecuencias acelerómetro 30/08/2017')
xlabel('frecuencia (Hz)')
ylabel('mm^2/s^3')

figure(3)
%FUNCTION SPECTROGRAM
%con la función spectrogram se puede realizar el espectrograma de la
%figura, donde x representa el vector de amplitud, 2024 es el tamaño de
%ventana, 1012, es el traslape, 2024 el num de datos a los cuales se les
%realiza la transformada de Fourier, 100 es el sps. 
%spectrogram(data,sizewindow,nslap,nfft,fs o sps)
spectrogram(d,4000,2000,4000,sps,'yaxis');