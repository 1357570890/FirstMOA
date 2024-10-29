function new_pop = lostrand(pop, maxpop, iteration, max_iterations)
    current_pop_size = size(pop, 1);
    
    if current_pop_size > maxpop * 1.3
        num_to_remove = current_pop_size - maxpop;
        max_loss_ratio = 0.01; 
        loss_ratio = max_loss_ratio * (1 - (iteration / max_iterations));
        loss_ratio = max(loss_ratio, 0);
        adjusted_num_to_remove = round(num_to_remove * loss_ratio);
        adjusted_num_to_remove = max(adjusted_num_to_remove, 0);

        if adjusted_num_to_remove > 0
            indices_to_remove = randperm(current_pop_size, adjusted_num_to_remove);
        else
            indices_to_remove = [];
        end

        new_pop = pop;
        new_pop(indices_to_remove, :) = [];
        
        if size(new_pop, 1) <= maxpop
            error('Population size cannot exceed maxpop');
        end
    else
        new_pop = pop;
    end
end
