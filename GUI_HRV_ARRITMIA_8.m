close all;clear all; clc;

load Irina600hz.mat
ecg=x';
N=length(ecg);
fs=600;
time=(0:N-1)/fs;

deltat=time(length(time))/length(time);
fs=1/deltat;
gr=1;

%% SE NECESITA EL DETECTOR DE QRS PARA TRABAJAR CON SUS VARIABLES RESULTANTES
[qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(ecg,fs,gr);

% qrs_amp_raw : amplitude of R waves amplitudes
% qrs_i_raw : index of R waves

%% Distancia temporal R-R
ks=qrs_i_raw; % Posición de muestra de cada pico R
kt=ks.*(1/fs); % Posición tiempo de cada pico R
kl=length(ks); % Número de picos R
for i=1:kl
    if i+1<=kl
        s(i)=kt(i+1)-kt(i);
    end
end
RR=s; % Distancia R-R en tiempo
RR_s=round(s.*fs); % Distancia R-R en muestras
%% % Intervalos NN: intervalos RR filtrando aquellos que difieran en más de un 20% del anterior
NN=s; 
L=length(NN); 
avg=mean(NN);
std=std(NN);
for i=1:length(s) 
    if i+1<=L
         if (abs(NN(i)-NN(i+1))/NN(i))*100>20 % Intervalos NN: intervalos RR filtrando aquellos que difieran en más de un 20% del anterior
            if (avg-std<NN(i)) && (NN(i)<avg+std)
                    NN(i+1)=0;
            else
                    NN(i)=0;
            end
            NN=NN(NN~=0); % Remuevo los ceros.
            L=length(NN);
         end
    end
end

NN_s=round(NN.*fs);  % Distancia N-N en muestras
%% AVNN & SDNN
AVNN=mean(NN);
SDNN=sqrt(sum((NN - mean(NN)).^2)./(length(NN)-1));
%% Intervalos temporales NN-NN & RMSSD & SDSD
for i=1:length(NN)
    if i+1<=length(NN)
        NN_interval(i)=abs(NN(i+1)-NN(i)); % Diferencia temporal entre un intervalo y su siguiente
    end
end
RMSSD=sqrt(mean(NN_interval.^2));
SDSD=sqrt(sum((NN_interval - mean(NN_interval)).^2)./(length(NN_interval)-1));
%% NN50 & pNN50
count=0;
vector_alarma=zeros(1,length(NN));
for i=1:length(NN)
    if i+1<=length(NN)
        if abs(NN(i+1)-NN(i))>=50/1000; % Cuenta las veces que el intervalo siguiente del actual difiere 50/1000 segundos.
            count=count+1;
            vector_alarma(i)=1;
        end
    end
end
NN50=count;
pNN50=count/length(NN);
NNms=round(NN.*1000);
NNbpm=round((60*1000*1)./NNms);
%% mean/avg/std^2 of RR & NN
NN_mean=mean(NN);
RR_mean=mean(RR);
NN_var=var(NN);
RR_var=var(RR);

figure(3)
histogram(RR)
xlabel('Tiempo')
ylabel('Frecuencia Absoluta')
grid on

figure(4)
xaxis=1:1:length(vector_alarma);
plot(xaxis,vector_alarma,'*')
xlabel('Pares NN')
ylabel('Alarma')
grid on

%% Gráfico de Arritmia basándonos en los Latidos por Segundo frente a cada intervalo NN
figure(5)
plot(NNbpm,'*')
xlabel('Pares NN')
ylabel('Latidos')
grid on

