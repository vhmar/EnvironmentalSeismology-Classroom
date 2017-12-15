clear all
close all
clc


load('30agos2016Geo.mat');

%%% primeramente se generará el vector tiempo, el cual corresponde a la
%%% primer columna 
t=agos30Geo(:,1);
t=datevec(t);
dt=(t(2,6));
sps=1/dt;

%el muestreo comenzó a las 10 de la noche 
%vector de tiempo
t=[0:dt:(length(t)-1)*dt]'*(1/3600);
%tiempo de muestreo 
time=length(t)*dt;

x=agos30Geo(:,2);
%el vector de datos, tiene algunos valores no definidos NAN, por lo que
%debemos de convertirlos a 0, al menos para saber cuantos datos son se
%realiza la sig. operación 
%se convierten los datos a 0
x(isnan(x))=0;

% tenemos los datos en cuentas, por lo que se debe de transformar a m/s

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
xlabel("tiempo (hr)")
ylabel("velocidad (mm/s)")

%%% se construye el espectro de frecuencias
[Pxx,Fx] = spectrum2(d,sps);

figure(2)
plot(Fx,Pxx,'r')
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
spectrogram(d,3000,1500,3000,sps,'yaxis');

%posiblemente se está realizando mal el muestreo, debido a que la respuesta
%instrumental del geofono parte a partir de los 10 hz, por lo que las bajas
%frecuencias contaminan el muestreo, es necesario eliminar las primeras
%frecuencias 

