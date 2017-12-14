clear all
close all
clc
load('26agos2016ACZ.mat');
t=AC26Z(:,1);
t=datevec(t);
dt= 0.01;
sps=1/0.01;
t=[0:dt:(length(t)-1)*dt]';
time=length(t)*dt;

x=AC26Z(:,2);
media=mean(x);
x=x-media;
x=detrend(x);
figure (1)
plot(t,x)
title("senal original")
xlabel("tiempo (s)")
ylabel("amplitud")

%NO HAY VALORES NULOS
NA=find(isnan(x));

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
spectrogram(x,3000,1500,3000,100,'yaxis');
