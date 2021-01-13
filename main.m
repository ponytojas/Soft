%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Practica final
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; clc;
addpath('dado/utils/');addpath('dado/dt/')
load('dado/dt/pwrCurve.mat');

%% Load Data
load('WindSym_1.mat');

%% Kgr Grid with Nturb Turbines
Kgr = 20;   % Tamaño del Grid
Nturb = 20; % Numero de Turbinas
steps = 1000; % Numero de iteraciones
TempIni  = 250;
DecrementoTempCnst = 1; % 1 true, 0 false
DecrementoTemp = 0.3; % Decremento de temperatura
K = 5; % Numero de mutaciones por iteracion

% Generacion de campo aleatorio inicial
gr = zeros(Kgr); gr(randperm(Kgr^2,Nturb)) = 1;     % Gen Nturb in a grid of Kgr x Kgr
[pwr_T2,~,~,~] = f_powerPlantsT_fast(vVec,gr);

T = TempIni;
iter = 0;
Tmin = (TempIni / (DecrementoTemp*(1 + steps)));

historico_fitness = ones(1,steps);
x = ones(1,steps);
contador = 0;

% Calculo de A con probabilidad 0.9 inicial o similar

while(T > Tmin)
    iter = iter + 1;
    for index = 1 : 30
       % Mutacion
        gr_new = mutacion(gr,K, Kgr);

        [pwr_T2_new,~,~,~] = f_powerPlantsT_fast(vVec,gr_new);

        if(pwr_T2 < pwr_T2_new)
            gr = gr_new;
            pwr_T2 = pwr_T2_new;
        elseif (rand < exp(-((100)/T*0.5)))
               gr = gr_new;
               pwr_T2 = pwr_T2_new;
               contador = contador + 1;
        end 
    end

    T = TempIni / (DecrementoTemp * (1 + iter));
    if(T > TempIni)
        T = TempIni;
    end
    
    historico_fitness(iter) = pwr_T2;
    x(iter) = iter;
    
end

%% Dibujar grafica
figure
plot(x, historico_fitness);

title('Temple Simulado')
xlabel('Iteraciones')
ylabel('Fitness')

fprintf('Potencia Total de %d Turbinas dispuestas aleatoriamente en un grid de %dx%d durante 1 año de simulación\n',Nturb,Kgr,Kgr);
disp(pwr_T2)

disp(contador)