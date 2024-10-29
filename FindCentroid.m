function centroid = FindCentroid(p)
    n = length(p(2).Arg); % 获取种群中个体的数量
    m = length(p(2).Arg(1).Arg);  % 获取每个个体的决策变量数量
    
    % 初始化质心
    centroid = zeros(1, m); 

    % 计算质心
    for i = 1:n
        centroid = centroid + p(2).Arg(i).Arg; % 累加每个个体的决策变量
    end
    centroid = centroid / n; % 计算质心，即累加和除以个体数量

end
