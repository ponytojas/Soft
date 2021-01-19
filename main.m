%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Practica final %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; clc;
addpath('dado/utils/');addpath('dado/dt/')
load('dado/dt/pwrCurve.mat');
rng shuffle
%% Load Data
load('WindSym_1.mat');

%% Kgr Grid with Nturb Turbines
Kgr = 20;   % Tamaño del Grid
Nturb = 20; % Numero de Turbinas
steps = 1000; % Numero de iteraciones
TempIni  = 250;
DecrementoTempCnst = 1; % 1 true, 0 false
DecrementoTemp = 0.3; % Decremento de temperatura
K = 3; % Numero de mutaciones por iteracion

% Generacion de campo aleatorio inicial
gr = zeros(Kgr); gr(randperm(Kgr^2,Nturb)) = 1;     % Gen Nturb in a grid of Kgr x Kgr
[pwr_T2,~,~,~,pwrGenIndv_T] = f_powerPlantsT_fast(vVec,gr);

T = TempIni;
iter = 0;
Tmin = (TempIni / (DecrementoTemp*(1 + steps)));

historico_fitness = ones(1,steps);
x = ones(1,steps);
contador = 0;

historico_temp = ones(1,steps);
historico_sin_entrar = ones(1, steps);
historio_mutaciones = ones(1, steps);

sin_entrar = 0;
cantidad_mutaciones = K;

while(T > Tmin)
    iter = iter + 1;
    for index = 1 : 15
        
%         if(sin_entrar > 20)
%             if(mod(sin_entrar, 20) == 0)
%                  if(cantidad_mutaciones ~= 1)
%                      cantidad_mutaciones =  cantidad_mutaciones - 1;
%                  end
%             end
%         end
        
       % Mutacion
        gr_new = mutacion(gr, cantidad_mutaciones, Kgr, pwrGenIndv_T);

        [pwr_T2_new,~,~,~, pwrGenIndv_T_new] = f_powerPlantsT_fast(vVec,gr_new);

% Generacion aleatoria de nuevo grid
%         gr_new = zeros(Kgr); gr_new(randperm(Kgr^2,Nturb)) = 1;
%         [pwr_T2_new,~,~,~,pwrGenIndv_T_new] = f_powerPlantsT_fast(vVec,gr_new);


        if(pwr_T2 < pwr_T2_new)
            gr = gr_new;
            pwr_T2 = pwr_T2_new;
            pwrGenIndv_T = pwrGenIndv_T_new;
            sin_entrar = 0;
%             cantidad_mutaciones = K;
        elseif (rand < exp(-((TempIni/15)/(T*0.5))))
               gr = gr_new;
               pwr_T2 = pwr_T2_new;
               pwrGenIndv_T = pwrGenIndv_T_new;
               contador = contador + 1;
               sin_entrar = 0;
%                cantidad_mutaciones = cantidad_mutaciones + round(cantidad_mutaciones*0.5);
%                if(cantidad_mutaciones > 20)
%                     cantidad_mutaciones = 20;
%                end
        else
            sin_entrar = sin_entrar + 1;
        end 
    end

    T = TempIni / (DecrementoTemp * (1 + iter));
    if(T > TempIni)
        T = TempIni;
    end
    
    historico_fitness(iter) = pwr_T2;
    x(iter) = iter;
    historico_temp(iter) = T;
    historico_sin_entrar(iter) = sin_entrar;
    historio_mutaciones(iter) = cantidad_mutaciones;
    
end

%% Dibujar grafica Fitness
figure
plot(x, historico_fitness);

title('Temple Simulado')
xlabel('Iteraciones')
ylabel('Fitness')


%% Dibujar grafica Temperaturas
figure
plot(x, historico_temp);

title('Temperaturas')
xlabel('Iteraciones')
ylabel('Temperatura')

%% Dibujar grafica Temperaturas
figure
plot(x, historico_sin_entrar);

title('Veces que no se ha entrado')
xlabel('Iteraciones')
ylabel('Cantidad de iteraciones sin entrar')


%% Dibujar grafica Temperaturas
figure
plot(x, historio_mutaciones);

title('Mutaciones')
xlabel('Iteraciones')
ylabel('Mutaciones que se van a realizar')



%% Dibujar el campo 20x20
pcolor(gr);
axis image
axis ij

%% Pintar en pantalla los resultados
fprintf('Potencia Total de %d Turbinas dispuestas aleatoriamente en un grid de %dx%d durante 1 año de simulación\n',Nturb,Kgr,Kgr);
disp(pwr_T2)

disp(contador)
