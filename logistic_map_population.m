function population = logistic_map_population(r, x0_base, nPop, nVar, burn_in)
    % logistic_map_population 使用Logistic映射生成种群
    % r: Logistic映射的参数
    % x0_base: 基础初始值
    % nPop: 种群大小
    % nVar: 决策变量数量
    % burn_in: 热身期，去除前burn_in个值

    population = zeros(nPop, nVar);
    for var = 1:nVar
        % 为每个变量添加微小扰动，避免完全相同的初始值
        perturb = (rand() - 0.5) * 0.1; 
        xi0 = x0_base + perturb; 
        xi0 = min(max(xi0, 0.01), 0.99); % 保证初始值在 (0,1) 内
        x = logistic_map(r, xi0, nPop + burn_in);
        x = x(burn_in+1:end);
        population(:, var) = x;
    end
end