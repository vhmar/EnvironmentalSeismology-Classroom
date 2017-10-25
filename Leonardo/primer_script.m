%%% Los sismos vienen dados dos columnas, la primera de ellas supongo que
%%% es tiempo y la segunda es el sismo como tal, por lo que para graficar
%%% se debe de realizar lo siguiente 

%%%se carga el archivo y despues de eso se selecciona la segunda columna y
%%%se plotea

%%%%%%%%los archivos se llaman
clear all
close all
clc

%load('26agos2016BBZ.mat');
%load('26agos2016ACZ.mat');
load('26agos2016Geo.mat');
%load('30agos2016ACZ.mat');                           
%load('30agos2016BBZ.mat');                                  
%load('30agos2016Geo.mat');

%%% primeramente se generará el vector tiempo, el cual corresponde a la
%%% primer columna 
t=agos26Geo(:,1);
t=datevec(t);
%delta de tiempo, el espacio de t que hay entre dato y dato
dt= 0.0040;
%muestras por segundo (sample per second)
sps=1/0.004;
%vector de tiempo
t=[0:dt:length(t)*dt]';
t(1)=[];
%tiempo de muestreo 
time=14400;

%%%el evento inicio las cuentas a las 21 horas, 0 minutos y 0 segundos
%el evento termino a las 24 horas, 59 minutos, 59.9960 segundos
%%%ahora se construira el vector de eventos, por lo que el evento duró 4
%%%horas
x=agos26Geo(:,2);

%el vector de datos, tiene algunos valores no definidos NAN, por lo que
%debemos de convertirlos a 0, al menos para saber cuantos datos son se
%realiza la sig. operación 
NA=find(isnan(x));
NA=zeros(size(NA));
%se convierten los datos a 0
x(isnan(x))=0;
figure (1)
plot(t,x)
title("senal original")
xlabel("tiempo (s)")
ylabel("amplitud")

%se realiza el calculo de la transformada de fourier y se crea el vector de
%frecuencias
fourier=abs(fft(x));

%se construye el vector de frecuencias
frecvec=linspace(0,sps,sps*time)';
length(frecvec);
fr=length(fourier);
fr=0.5*fr;

figure(2)
plot(frecvec(1:fr),fourier(1:fr),'r')
