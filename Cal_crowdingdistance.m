function pop = Cal_crowdingdistance(pop, F)
    % 计算种群中个体的拥挤度
    % pop: 当前种群
    % F: 非支配排序的个体索引

    nF = numel(F); % 获取非支配排序的个体数量
    for k = 1 : nF
        Objs = [pop(F{k}).Obj]; % 获取当前非支配层的目标值
        nObj = size(Objs, 1); % 获取目标函数的数量
        n = numel(F{k}); % 获取当前非支配层的个体数量
        d = zeros(n, nObj); % 初始化拥挤度矩阵

        for j = 1 : nObj
            [obj, ind] = sort(Objs(j,:), 'ascend'); % 对目标值进行升序排序
            d(ind(1), j) = inf; % 最小值的拥挤度设为无穷大
            for i = 2 : n - 1
                % 计算拥挤度
                d(ind(i), j) = abs(obj(i+1) - obj(i-1)) / abs(obj(1) - obj(end));
            end
            d(ind(end), j) = inf;  % 最大值的拥挤度设为无穷大
        end

        for i = 1 : n
            % 将每个个体的拥挤度设置为所有目标的拥挤度之和
            pop(F{k}(i)).CrowdingDistance = sum(d(i, :));
        end
    end
end
