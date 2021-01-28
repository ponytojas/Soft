%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Practica final %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Limpiamos datos antiguos, terminal, incluimos ficheros y generamos los 
% numeros pseudo aleatorios
clear; close all; clc;
addpath('dado/utils/');addpath('dado/dt/')
load('dado/dt/pwrCurve.mat');
rng shuffle


%% Load Data
load('WindSym_1.mat');


%% Configuracion de la ejecucion
% Tamaño del Grid
Kgr = 20;

% Numero de Turbinas
Nturb = 20;

% Numero de iteraciones
steps = 1000; 

% Temperatura inicial
TempIni  = 250;

% Decremento de temperatura
DecrementoTemp = 0.3;

% Numero de mutaciones
K = 12;

if (K > Nturb)
   K = Nturb; 
end

% Veces que es necesario no entrar a modificar el valor de fitness 
% para modificar las mutaciones
cambiar_mutaciones = 20; 

% Cantidad de veces antes de salir del programa que no se actualiza el valor
% 15.000 => 1000 iteraciones de 15 generaciones cada iteracion
limite_sin_entrar = 15000; 

% Las generaciones se realizan con mutaciones si es 0 o mediante aleatorios
% si es 1
aleatorio = 0; 

% Variable para controlar si las mutaciones deben ser fijas o no
mutaciones_fijas = 0;

% Cantidad de mutaciones del mas optimo o generaciones automaticas por cada
% iteracion que realizamos
cantidad_por_iteracion = 15;
                         
%% Generacion de campo aleatorio inicial

% Gen Nturb in a grid of Kgr x Kgr
gr = zeros(Kgr); gr(randperm(Kgr^2,Nturb)) = 1;  


%% Obtencion del fitness inicial
[pwr_T2,~,~,~,pwrGenIndv_T] = f_powerPlantsT_fast(vVec,gr);


%% Inicializacion de las variables utilizadas para las graficas
historico_fitness = ones(1,steps);
x = ones(1,steps);
historico_temp = ones(1,steps);
historico_sin_entrar = ones(1, steps);
historico_mutaciones = ones(1, steps);


%% Configuracion de las temperaturas minimas y la que ira descendiendo
T = TempIni;
Tmin = (TempIni / (DecrementoTemp*(1 + steps)));


%% Configuracion inicial de las variables de control
iter = 0;
contador = 0;
sin_entrar = 0;
cantidad_mutaciones = K;
fin = 0;

%% Kgr Grid with Nturb Turbines
while(T > Tmin && ~fin)
    iter = iter + 1;
    
    % Por cada descenso de temperatura realizamos diferentes mutaciones
    % o generaciones aleatorias
    for index = 1 : cantidad_por_iteracion
        
        % Paramos el sistema si durante muchas iteraciones no hemos
        % mejorado
        if(sin_entrar >= limite_sin_entrar)
            disp("No esta siendo posible mejorar los resultados, salimos");
            fin = 1;
            break;
        end
        
        % Modificamos la cantidad de mutaciones que generamos reduciendo en
        % uno las mutaciones que estabamos realizando
        if(~mutaciones_fijas && ~aleatorio && cantidad_mutaciones ~= 1 && sin_entrar > cambiar_mutaciones )
            if(mod(sin_entrar, cambiar_mutaciones) == 0)
                 cantidad_mutaciones =  cantidad_mutaciones - 1;
            end
        end
        
        % Si la variable de control aleatorio es 0 generamos mediante
        % mutacion, sino mediante generacion aleatoria
        if(~aleatorio)
           % Mutacion
           gr_new = mutacion(gr, cantidad_mutaciones, Kgr, pwrGenIndv_T);
           [pwr_T2_new,~,~,~, pwrGenIndv_T_new] = f_powerPlantsT_fast(vVec,gr_new);
        else
           % Generacion aleatoria de nuevo grid
           gr_new = zeros(Kgr); gr_new(randperm(Kgr^2,Nturb)) = 1;
           [pwr_T2_new,~,~,~,pwrGenIndv_T_new] = f_powerPlantsT_fast(vVec,gr_new);
        end
        

        % Si el valor fitness es mejor que el anterior, sustituimos
        if(pwr_T2 < pwr_T2_new)
            gr = gr_new;
            pwr_T2 = pwr_T2_new;
            pwrGenIndv_T = pwrGenIndv_T_new;
            sin_entrar = 0;
            cantidad_mutaciones = cantidad_mutaciones + round(cantidad_mutaciones*0.5);
        % Existe una probabilidad de que sustituyamos aunque sea un
        % resultado peor para evitar maximos locales
        elseif (rand < exp(-((TempIni/15)/(T*0.5))))
               gr = gr_new;
               pwr_T2 = pwr_T2_new;
               pwrGenIndv_T = pwrGenIndv_T_new;
               contador = contador + 1;
               sin_entrar = 0;
               cantidad_mutaciones = cantidad_mutaciones + round(cantidad_mutaciones*0.5);
              
        else
            sin_entrar = sin_entrar + 1;
        end 
        
        % Limitamos el maximo de mutaciones que pueden realizarse
        if(cantidad_mutaciones > K)
            cantidad_mutaciones = K;
        end
    end
    

    % Decrementamos la temperatura actual
    T = TempIni / (DecrementoTemp * (1 + iter));
    
    % En un primer momento la temperatura puede ser superior asi que lo
    % comprobamos
    if(T > TempIni)
        T = TempIni;
    end
    
    % Añadimos los datos para mostrar las graficas
    historico_fitness(iter) = pwr_T2;
    x(iter) = iter;
    historico_temp(iter) = T;
    historico_sin_entrar(iter) = sin_entrar;
    historico_mutaciones(iter) = cantidad_mutaciones;
    
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
plot(x, historico_mutaciones);

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
