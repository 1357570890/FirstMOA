function population = AdjustPopulation(pop, arc, a, minValue, maxValue)
    nVar = length(pop(1).Arg);
    
    % 获取 Rank 等于 1 的个体
    rank1_individuals = arc(1).Arg([arc(1).Arg.Rank] == 1);
    
    % 如果 Rank 1 的个体数量大于 3
    if length(rank1_individuals) > 3
        % 随机选择 3 个个体
        selected_individuals = rank1_individuals(randperm(length(rank1_individuals), 3));
    else
        % 如果个体数量小于等于 3，选择所有 Rank 1 的个体
        selected_individuals = rank1_individuals;
        
        % 如果 Rank 1 的个体数量小于 2，选择 Rank 2 的个体
        if length(selected_individuals) < 2
            rank2_individuals = arc(1).Arg([arc(1).Arg.Rank] == 2);
            selected_individuals = [selected_individuals; rank2_individuals]; % 追加
        end
        
        % 如果个体数量仍然小于 2，选择 Rank 3 的个体
        if length(selected_individuals) < 2
            rank3_individuals = arc(1).Arg([arc(1).Arg.Rank] == 3);
            selected_individuals = [selected_individuals; rank3_individuals]; % 追加
        end
    end

    % 选择三个个体
    Delta = selected_individuals(1);
    Beta = selected_individuals(2);
    Alpha = selected_individuals(3);

    for i = 1:length(pop)
        % 生成随机数
        c = 2 .* rand(1, nVar);  % 生成随机系数
        
        % 计算 Delta 个体的更新位置
        D = abs(c .* Delta.Arg - pop(i).Arg);
        A = 2 .* a .* rand(1, nVar) - a;
        X1 = Delta.Arg - A .* abs(D);
        
        % 计算 Beta 个体的更新位置
        c = 2 .* rand(1, nVar);  % 生成随机系数
        D = abs(c .* Beta.Arg - pop(i).Arg);  % 计算差值
        A = 2 .* a .* rand(1, nVar) - a;  % 生成随机系数
        X2 = Beta.Arg - A .* abs(D);  % 计算更新位置 X2
        
        % 计算 Alpha 个体的更新位置
        c = 2 .* rand(1, nVar);  % 生成随机系数
        D = abs(c .* Alpha.Arg - pop(i).Arg);  % 计算差值
        A = 2 .* a .* rand(1, nVar) - a;  % 生成随机系数
        X3 = Alpha.Arg - A .* abs(D);  % 计算更新位置 X3
        
        % 更新当前个体的位置
        k1 = 1;
        k2 = 1;
        k3 = 1;
        newArg = (k1 * X1 + k2 * X2 + k3 * X3) ./ 3;
        
        % 检查新的决策变量是否在指定范围内
        if all(newArg >= minValue) && all(newArg <= maxValue)
            % 更新个体的决策变量
            pop(i).Arg = newArg;  
        end
    end
    
    % 返回更新后的种群
    population = pop;
end
