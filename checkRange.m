function [isInRange, outOfRangeIndices] = checkRange(minValue, maxValue, arr)
    % 检查数组中的元素是否在指定范围内
    % minValue: 最小值
    % maxValue: 最大值
    % arr: 输入数组
    % isInRange: 布尔值，指示是否所有元素都在指定范围内
    % outOfRangeIndices: 超出范围的元素的索引

    % 找到超出范围的元素的索引
    outOfRangeIndices = find(arr < minValue | arr > maxValue);
    
    % 如果没有超出范围的元素，则返回 true 和空数组
    if isempty(outOfRangeIndices)
        isInRange = true; % 所有元素都在范围内
        outOfRangeIndices = []; % 空数组
    else
        isInRange = false; % 存在超出范围的元素
    end
end
