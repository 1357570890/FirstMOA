function distance = Cal_distance(Individual1, Individual2)
    % 计算两个个体之间的欧几里得距离
    if size(Individual1) ~= size(Individual2)
        error('输入的个体必须具有相同的维度');
    end
    
    % 初始化距离为0
    distance = 0;
    
    % 计算每个维度的差值的平方和
    for i = 1:length(Individual1)
        distance = distance + (Individual1(i) - Individual2(i))^2; % 累加每个维度的差的平方
    end
    
    % 取平方和的平方根，得到欧几里得距离
    distance = sqrt(distance);
end
