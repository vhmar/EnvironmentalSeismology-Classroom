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
dt=(t(2,6));
sps=1/dt;

% el muestreo comenzó a las 9 de la noche, del 26 de agosto del 2016

%vector de tiempo
t=[0:dt:(length(t)-1)*dt]'*(1/3600);
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


%%% tenemos los datos en cuentas, por lo que se debe de transformar a m/s

% sensitivity = 22.8 V/m/sec
% AD converter: 32 bits e 5V picco-picco
% 1 count = 1.164153 nV
x=x*1.164153*10^-9;
x=x/22.8;
x=x*10^3;

%se construye el pasabandas de 10 a 120 hz
[d]=bandpass(x,10,120,dt);
figure (1)
plot(t,d)
title("senal original geófono")
xlabel("tiempo (s)")
ylabel("velocidad (m/s)")

%%% se construye el espectro de frecuencias
[Pxx,Fx] = spectrum2(d,sps);

figure(2)
plot(Fx,Pxx,'r')
title('espectro de frecuencias geófono 26/08/2017')
xlabel('frecuencia (Hz)')
ylabel('velocidad mm^2/s')

figure(3)
%FUNCTION SPECTROGRAM
%con la función spectrogram se puede realizar el espectrograma de la
%figura, donde x representa el vector de amplitud, 2024 es el tamaño de
%ventana, 1012, es el traslape, 2024 el num de datos a los cuales se les
%realiza la transformada de Fourier, 100 es el sps. 
%spectrogram(data,sizewindow,nslap,nfft,fs o sps)
spectrogram(d,3000,1500,3000,sps,'yaxis');

%posiblemente se está realizando mal el muestreo, debido a que la respuesta
%instrumental del geofono parte a partir de los 10 hz, por lo que las bajas
%frecuencias contaminan el muestreo, es necesario eliminar las primeras
%frecuencias 
