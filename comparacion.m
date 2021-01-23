%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Generar grafica comparativa %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load comparacion.mat
load sin_entrar.mat

%% Generacion de grafica comparativa de resultados
figure
plot(x,random_fitness) 
hold on 
plot(x, tres_mutaciones)
hold on
plot(x,una_mutacion) 
hold on 
plot(x,variable_mutaciones)
hold off
legend('Valores aleatorios', 'Tres mutaciones fijas', 'Una mutacion fija', 'Mutaciones variables')
title('Comparacion de resultados')
xlabel('Iteraciones')
ylabel('Valor fitness');

%% Generacion de grafica comparativa de las veces sin entrar
figure
plot(x,sin_entrar_aleatorio) 
hold on 
plot(x, sin_entrar_tres)
hold on
plot(x, sin_entrar_uno) 
hold on 
plot(x, sin_entrar_variable)
hold off
legend('Valores aleatorios', 'Tres mutaciones fijas', 'Una mutacion fija', 'Mutaciones variables')
title('Comparacion de veces sin entrar')
xlabel('Iteraciones')
ylabel('Veces sin entrar');