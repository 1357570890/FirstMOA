function m = Mutate(p, xmin, xmax)
    % 输入参数:
    % p: 当前个体的染色体
    % xmin: 染色体中每个变量的最小值
    % xmax: 染色体中每个变量的最大值
    
    n = numel(p); % 获取染色体的维度数量
    ind = randperm(n, 1); % 随机选择一个索引，用于变异操作
    m = p; % 初始化变异后的个体为当前个体
    
    % 在随机选择的索引位置进行变异
    m(ind) = xmin + (xmax - xmin) * rand; % 生成一个在 [xmin, xmax] 范围内的随机值
end
