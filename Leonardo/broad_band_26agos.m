%Datos del ancho de bandas del evento del 26 de agosto

clear all
close all
clc
load('26agos2016BBZ.mat');

t=BBZ26(:,1);
t=datevec(t);
%%% este evento inicio el 26 de agosto a las 21:00:00 y terminó el 27
%%% agosto a las 00:35:44.4200, por lo que es de menor duración que los
%%% otros
%delta de tiempo, el espacio de t que hay entre dato y dato
dt= 0.010;
%muestras por segundo (sample per second)
sps=1/0.01;
%vector de tiempo
t=[0:dt:(length(t)-1)*dt]';
%tiempo de muestreo 
time=length(t)*dt;
%el evento inicio las cuentas a las 21 horas, 0 minutos y 0 segundos
%el evento termino a las 24 horas, 59 minutos, 59.9960 segundos
%%%ahora se construira el vector de eventos, por lo que el evento duró 4
%%%horas
x=BBZ26(:,2);

%el vector de datos, tiene algunos valores no definidos NAN, por lo que
%debemos de convertirlos a 0, al menos para saber cuantos datos son se
%realiza la sig. operación 
NA=find(isnan(x));


%%%ahora debemos eliminar las tendencias lineales
media=mean(x);
x=x-media;
x=detrend(x);
figure (1)
plot(t,x)
title("senal original")
xlabel("tiempo (s)")
ylabel("amplitud")



Nx = length(x);
w = hann(Nx);
xw = x.*w; 
%se realiza el calculo de la transformada de fourier y se crea el vector de
%frecuencias
nfft = 2^nextpow2(Nx);%Nx; 
X = fft(xw,nfft);
mx = abs(X).^2; 
%se construye el vector de frecuencias

frecvec=linspace(0,sps,sps*(time))';
length(frecvec);
fr=length(mx);
fr=0.5*(fr);

figure(2)
plot(frecvec(2:fr),mx(2:fr),'r')

figure(3)
%FUNCTION SPECTROGRAM
%con la función spectrogram se puede realizar el espectrograma de la
%figura, donde x representa el vector de amplitud, 2024 es el tamaño de
%ventana, 1012, es el traslape, 2024 el num de datos a los cuales se les
%realiza la transformada de Fourier, 100 es el sps. 
%spectrogram(data,sizewindow,nslap,nfft,fs o sps)
spectrogram(x,2024,1012,2024,100,'yaxis');
