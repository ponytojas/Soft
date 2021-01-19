function gr = mutacion(gr, K, Kgr, pwrGenIndv_T)
    
    result = find(gr==1);
    if(0.75 < rand)
       mutation_vector = randperm(20,K);
       index_to_change = result(mutation_vector);
       gr(index_to_change) = 0;
       result(mutation_vector) = [];
    else
        [~,min_index] = sort(pwrGenIndv_T);
        index_to_change = result(min_index(1:K));
        gr(index_to_change) = 0;
        result(min_index(1:K)) = [];
    end
    
    
    new_elements = randperm(Kgr^2, K);
    [~,~,ind]  = intersect(result,new_elements);
    new_elements(ind) = [];
    while(length(new_elements) ~= K)
        temp = randperm(Kgr^2, K - length(new_elements));
        [~,~,indTemp]  = intersect(new_elements,temp);
        temp(indTemp) = [];
        new_elements = [new_elements temp];
        [~,~,ind]  = intersect(result,new_elements);
        new_elements(ind) = [];
    end
    gr(new_elements) = 1;
    if(length(gr(gr == 1)) ~= 20)
        fprintf('La cantidad de turbinas ha sido');
        disp(length(gr(gr == 1)))
        fprintf('Ha habido un error al generar las mutaciones, volvemos a entrar');
        gr = mutacion(gr, K, Kgr, pwrGenIndv_T);
    end
end
