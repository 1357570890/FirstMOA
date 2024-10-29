function new_pop = nextstrategy(pop, generation)
    % 获取种群大小
    pop_size = size(pop, 1);
    num_variables = size(pop, 2);
    
    % 根据当前代数调整新种群大小
    % 新种群大小 = 当前种群大小 * (1 - 0.1 * 当前代数)
    new_pop_size = max(1, round(pop_size * (1 - 0.1 * generation))); % 确保至少有一个个体
    new_pop = zeros(new_pop_size, num_variables); % 初始化新种群

    % 生成新种群
    for i = 1:new_pop_size
        % 选择父代个体
        parent1 = select_parent(pop);
        parent2 = select_parent(pop);
        
        % 进行交叉操作
        child = crossover(parent1, parent2);
        
        % 进行变异操作
        child = mutate(child);
        
        % 将新个体添加到新种群中
        new_pop(i, :) = child;
    end
end

function parent = select_parent(pop)
    % 随机选择一个父代个体
    idx = randi(size(pop, 1));
    parent = pop(idx, :);
end

function child = crossover(parent1, parent2)
    % 进行线性交叉操作
    alpha = rand();
    child = alpha * parent1 + (1 - alpha) * parent2;
end

function mutated = mutate(individual)
    % 对个体进行变异操作
    mutation_rate = 0.1; % 变异概率
    if rand() < mutation_rate
        mutation_amount = randn(size(individual)) * 0.1; % 生成随机变异量
        mutated = individual + mutation_amount; % 应用变异
    else
        mutated = individual; % 如果没有变异，返回原个体
    end
end
