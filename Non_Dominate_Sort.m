function [pop, F] = Non_Dominate_Sort(pop)
    n = numel(pop);

    for i = 1:n
        pop(i).DominantSet = [];
        pop(i).Dominated = 0;
    end

    F{1} = [];
    for i = 1 : n
        for j = i+1 : n
            p = pop(i);
            q = pop(j);
            if all(p.Obj <= q.Obj) && any(p.Obj < q.Obj)
                p.DominantSet = [p.DominantSet, j];
                q.Dominated = q.Dominated + 1;
            elseif all(q.Obj <= p.Obj) && any(q.Obj < p.Obj)
                q.DominantSet = [q.DominantSet, i];
                p.Dominated = p.Dominated + 1;
            end
            pop(i) = p;
            pop(j) = q;
        end
        if pop(i).Dominated == 0
            F{1} = [F{1}, i];
            pop(i).Rank = 1;
        end
    end

    k = 1;
    while true
        Q = [];
        for i = F{k}
            p = pop(i);
            for j = p.DominantSet
                q = pop(j);
                q.Dominated = q.Dominated - 1;
                if q.Dominated == 0
                    q.Rank = k + 1;
                    Q = [Q, j];
                end
                pop(j) = q;
            end
        end
        if isempty(Q)
            break;
        else
            F{k+1} = Q;
            k = k + 1;
        end
    end
end
