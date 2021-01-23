%% Funcion de mutacion
%   gr Matriz de dimensiones cuadradas con valores 1 o 0, si tienen o no
%   generador
%   K Cantidad de mutaciones a realizar
%   Kgr Tamaño de la matriz
%   pwrGenIndv_T Potencia generada de forma individual en cada uno de los
%   generadores
function gr = mutacion(gr, K, Kgr, pwrGenIndv_T)
    
    % Inicialmente cogemos los indices de la matriz gr que tengan valor
    % igual a 1
    result = find(gr==1);
    
    % Implementamos una probabilidad aleatoria de que se mute por completo
    % la matriz de generadores
    if(0.75 < rand)
       % Generamos un vector de K valores
       mutation_vector = randperm(20,K);
       index_to_change = result(mutation_vector);
       gr(index_to_change) = 0;
       result(mutation_vector) = [];
    else
        % Ordenamos los indices de los generadores en funcion de la 
        % potencia que han generado de forma individual de menor a mayor
        [~,min_index] = sort(pwrGenIndv_T);
        % Cogemos los K elementos con peor potencia generada
        index_to_change = result(min_index(1:K));
        % Ponemos los valores de los peores generadores a 0
        gr(index_to_change) = 0;
        % Eliminamos del vector de generadores los K peores generadores
        result(min_index(1:K)) = [];
    end
    
    % Generamos un vector de K elementos y valores entre 1 y Dimensiones
    % de la Matriz al cuadrado
    new_elements = randperm(Kgr^2, K);
    % Obenemos los indices de la interseccion de los elementos que se
    % hubieran mantenido y los nuevos aleatorios
    [~,~,ind]  = intersect(result,new_elements);
    % Borramos los nuevos elementos que ya existieran para evitar
    % duplicidades
    new_elements(ind) = [];
    % Mientras la longitud de los nuevos elementos generados sea inferior a
    % la cantidad de mutaciones entramos en un bucle que realizara 
    while(length(new_elements) ~= K)
        temp = randperm(Kgr^2, K - length(new_elements));
        [~,~,indTemp]  = intersect(new_elements,temp);
        temp(indTemp) = [];
        new_elements = [new_elements temp];
        [~,~,ind]  = intersect(result,new_elements);
        new_elements(ind) = [];
    end
    % Ponemos a 1 (añadidmos generador) en la matriz en los nuevos
    % elementos
    gr(new_elements) = 1;
    % Si la longitud del vector de elementos es inferior a 20, volvemos a
    % entrar en el algoritmo hasta rellenar la cantidad necesaria
    if(length(gr(gr == 1)) ~= 20)
        fprintf('La cantidad de turbinas ha sido');
        disp(length(gr(gr == 1)))
        fprintf('Ha habido un error al generar las mutaciones, volvemos a entrar');
        gr = mutacion(gr, K, Kgr, pwrGenIndv_T);
    end
end
