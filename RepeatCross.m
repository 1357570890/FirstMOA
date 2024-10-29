function offspring = RepeatCross(p, xmin, xmax, lengthToCopy)
    n = numel(p); % 获取当前个体的维度数量
    offspring = p; % 初始化后代为当前个体

    % 随机选择起始索引
    startIdx = randi([1, n-1]); % 随机选择起始位置，确保有足够的空间进行复制

    % 检查复制长度是否超出范围
    if startIdx + lengthToCopy - 1 > n
        lengthToCopy = n - startIdx; % 调整复制长度以适应边界
    end

    % 随机选择复制方向
    if rand() < 0.5
        % 从起始位置向后复制
        offspring(startIdx:startIdx + lengthToCopy - 1) = p(startIdx:startIdx + lengthToCopy - 1);
    else
        % 从起始位置向前复制
        if startIdx - lengthToCopy + 1 < 1
            % 如果起始位置不足以向前复制，调整起始位置
            startIdx = lengthToCopy; % 确保起始位置在有效范围内
        end
        offspring(startIdx - lengthToCopy + 1:startIdx) = p(startIdx:startIdx + lengthToCopy - 1);
    end

    % 确保后代的值在 [xmin, xmax] 范围内
    offspring = max(min(offspring, xmax), xmin);
end
