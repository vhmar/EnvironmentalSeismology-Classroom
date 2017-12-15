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
dt=(t(2,6));
sps=1/dt;
%vector de tiempo
t=[0:dt:(length(t)-1)*dt]'*(1/3600);
%tiempo de muestreo 
time=length(t);
%el evento inicio las cuentas a las 21 horas, 0 minutos y 0 segundos
%el evento termino a las 24 horas, 59 minutos, 59.9960 segundos
%%%ahora se construira el vector de eventos, por lo que el evento duró 4
%%%horas
x=BBZ26(:,2);

%el vector de datos, tiene algunos valores no definidos NAN, por lo que
%debemos de convertirlos a 0, al menos para saber cuantos datos son se
%realiza la sig. operación 
NA=find(isnan(x));

%vamos a eliminar los valores de las horas anteriores, para que todos
%inicen a la misma hora 
%x=x(360000:end);

%se transforma a unidades físicas 
%1 m/s= 3.017*10^8
x=x*(1/(3.01719*10^8));
x=x*10^3;

%se crea el pasabandas, en mi caso deseo eliminar las bajas frecuencias
%debido a que me meten ruido posiblemente debido a las mareas

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
%set(gca, 'YLim', [1 1e9])
title('espectro de frecuencias Banda Ancha 26/08/2016')
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

