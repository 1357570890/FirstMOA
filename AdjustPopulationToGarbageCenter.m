function population = AdjustPopulationToGarbageCenter(pop, arc, minValue, maxValue)
    % 调整种群以远离垃圾中心
    % pop: 当前种群
    % arc: 存储历史个体的档案
    % minValue: 决策变量的最小值
    % maxValue: 决策变量的最大值

    ratio = 0.01; % 调整比例
    mindistance = 0.1; % 最小距离阈值

    % 计算垃圾中心（历史个体的质心）
    garbage_center = FindCentroid(arc);
    
    % 遍历种群中的每个个体
    for i = 1:length(pop)
        % 检查个体的等级
        if pop(i).Rank ~= 1
            % 如果个体与垃圾中心的距离大于最小距离
            if Cal_distance(pop(i).Arg, garbage_center) > mindistance
                % 计算新的决策变量
                newArg = pop(i).Arg - ratio * garbage_center;  
                
                % 检查新的决策变量是否在指定范围内
                if all(newArg >= minValue) && all(newArg <= maxValue)
                    % 更新个体的决策变量
                    pop(i).Arg = newArg;  
                end
            end
        end
    end
    
    population = pop; % 返回调整后的种群
end