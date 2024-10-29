function population = Savearchive(p)

    set_maxRank = 20; % 设置最大 Rank 的个体数量
    set_maxarc = 20;  % 设置最大存档个体数量
    set_max = 1; 

    n = size(p, 1);
    
    % 获取最大 Rank
    maxRank = max([p.Rank]);  % 获取个体中最大的 Rank 值
    
    % 初始化存档结构体
    population = repmat(struct('Arg', []), 2, 1);  
    
    % 存储 Rank 为 1、2 和 3 的个体到 population(1).Arg
    bestIndividuals = p([p.Rank] == 1);
    secondBestIndividuals = p([p.Rank] == 2);
    thirdBestIndividuals = p([p.Rank] == 3);
    
    % 合并最佳个体
    population(1).Arg = [bestIndividuals; secondBestIndividuals; thirdBestIndividuals];   % 存储最佳个体

    % 存储 Rank 较差的个体
    if maxRank > set_maxRank
        worstIndividuals = p(end-set_maxarc-1:end); % 直接使用 p 中的最后几个个体
    else
        worstIndividuals = p([p.Rank] == maxRank); % 存储当前最大 Rank 的个体
        
        % 如果个体数量少于 5，则取最后 15 个个体
        if length(worstIndividuals) < 5
            worstIndividuals = p(end-14:end);
        end
    end
    
    population(2).Arg = worstIndividuals; % 存储 Rank 较差的个体到 population(2).Arg
    
end
