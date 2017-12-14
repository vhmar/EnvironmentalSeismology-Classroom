%%% Los sismos vienen dados dos columnas, la primera de ellas supongo que
%%% es tiempo y la segunda es el sismo como tal, por lo que para graficar
%%% se debe de realizar lo siguiente 

%%%se carga el archivo y despues de eso se selecciona la segunda columna y
%%%se plotea

%%%%%%%%los archivos se llaman
clear all
close all
clc


load('26agos2016Geo.mat');

%%% primeramente se generará el vector tiempo, el cual corresponde a la
%%% primer columna 
t=agos26Geo(:,1);
t=datevec(t);
%delta de tiempo, el espacio de t que hay entre dato y dato
dt= 0.0040;
%muestras por segundo (sample per second) 250hz
sps=1/0.004;  
%vector de tiempo
t=[0:dt:(length(t)-1)*dt]';
%tiempo de muestreo 
time=length(t)*dt;

%%%el evento inicio las cuentas a las 21 horas, 0 minutos y 0 segundos
%el evento termino a las 24 horas, 59 minutos, 59.9960 segundos
%%%ahora se construira el vector de eventos, por lo que el evento duró 4
%%%horas
x=agos26Geo(:,2);

%el vector de datos, tiene algunos valores no definidos NAN, por lo que
%debemos de convertirlos a 0, al menos para saber cuantos datos son se
%realiza la sig. operación 
%se convierten los datos a 0
x(isnan(x))=0;
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
spectrogram(x,3000,1500,3000,100,'yaxis');

%posiblemente se está realizando mal el muestreo, debido a que la respuesta
%instrumental del geofono parte a partir de los 10 hz, por lo que las bajas
%frecuencias contaminan el muestreo, es necesario eliminar las primeras
%frecuencias 
figure(3)
