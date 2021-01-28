function gr = mutacion_original(gr, K, Kgr)
    result = find(gr==1);
    mutation_vector = randperm(20,K);
    index_to_change = result(mutation_vector);
    gr(index_to_change) = 0;
    result(mutation_vector) = [];
    
    new_elements = randperm(Kgr^2, K);
    [~,~,ind]  = intersect(result,new_elements);
    new_elements(ind) = [];
    while(length(new_elements) ~= 5)
        temp = randperm(Kgr^2, 5 - length(new_elements));
        [~,~,indTemp]  = intersect(new_elements,temp);
        temp(indTemp) = [];
        new_elements = [new_elements temp];
        [~,~,ind]  = intersect(result,new_elements);
        new_elements(ind) = [];
    end
    gr(new_elements) = 1;
    if(length(gr(gr == 1)) ~= 20)
        fprintf('La cantidad de turbinas ha sido');
        fprintf(length(gr(gr == 1)))
        fprintf('Ha habido un error al generar las mutaciones, volvemos a entrar');
        gr = mutacion_original(gr, K, Kgr);
    end
end