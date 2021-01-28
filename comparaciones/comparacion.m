%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Generar grafica comparativa %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear
load comparacion_fitness.mat
load comparacion_sin_entrar.mat
load comparacion_x.mat

%% Generacion de grafica comparativa de resultados
figure
plot(x, fitness_random) 
hold on 
plot(x, fitness_tres_mutaciones)
hold on
plot(x, fitness_una_mutacion) 
hold on 
plot(x, fitness_mutaciones_variables)
hold off
legend('Valores aleatorios', 'Tres mutaciones fijas', 'Una mutacion fija', 'Mutaciones variables')
title('Comparacion de resultados')
xlabel('Iteraciones')
ylabel('Valor fitness');

%% Generacion de grafica comparativa de las veces sin entrar
figure
plot(x, sin_entrar_random) 
hold on 
plot(x, sin_entrar_tres_mutaciones)
hold on
plot(x, sin_entrar_una_mutacion) 
hold on 
plot(x, sin_entrar_mutaciones_variables)
hold off
legend('Valores aleatorios', 'Tres mutaciones fijas', 'Una mutacion fija', 'Mutaciones variables')
title('Comparacion de veces sin entrar')
xlabel('Iteraciones')
ylabel('Veces sin entrar');