function pop = initialize_population(r, x0_base, nPop, nVar, xmin, xmax, objectiveFunction, burn_in)
    % initialize_population 初始化种群
    % r: Logistic映射的参数
    % x0_base: 基础初始值
    % nPop: 种群大小
    % nVar: 决策变量数量
    % xmin, xmax: 决策变量范围
    % objectiveFunction: 目标函数句柄
    % burn_in: 热身期，去除前burn_in个值

    % 生成通过Logistic映射的种群矩阵
    population = logistic_map_population(r, x0_base, nPop, nVar, burn_in);
    
    % 创建种群结构模板
    template.Arg = [];
    template.Obj = [];
    template.DominantSet = [];
    template.Dominated = 0;
    template.Rank = [];
    template.CrowdingDistance = [];
    
    % 初始化种群
    pop = repmat(template, nPop, 1);
    
    for i = 1:nPop
        % 将生成的值缩放到[xmin, xmax]范围内
        pop(i).Arg = xmin + (xmax - xmin) * population(i, :);
        pop(i).Obj = objectiveFunction(pop(i).Arg);
    end
end