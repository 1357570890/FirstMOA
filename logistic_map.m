function x = logistic_map(r, x0, n)
    % Logistic 映射的实现，包括热身期
    % r: Logistic 映射的参数
    % x0: 初始值
    % n: 生成的值的数量
    
    x = zeros(1, n);
    x(1) = x0;
    for i = 2:n
        x(i) = r * x(i-1) * (1 - x(i-1)); % Logistic 映射公式
    end
end