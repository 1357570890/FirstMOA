function newState = reverseDefection(currentState)
    % reverseDefection 反转策略函数
    % 输入:
    %   currentState - 当前策略状态 (0 或 1)
    % 输出:
    %   newState - 反转后的策略状态 (0 或 1)

    % 检查输入是否为有效状态
    if currentState ~= 0 && currentState ~= 1
        error('当前状态必须是0或1，输入无效');
    end

    % 反转策略
    newState = 1 - currentState; % 0 变为 1，1 变为 0
end
