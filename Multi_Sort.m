function pop = Multi_Sort(pop)
    % 根据拥挤度进行降序排序
    [~, ind_cd] = sort([pop.CrowdingDistance], 'descend'); % 按照拥挤度进行排序
    pop = pop(ind_cd); % 重新排列种群

    % 根据等级进行升序排序
    [~, ind_Rank] = sort([pop.Rank], 'ascend'); % 按照等级进行排序
    pop = pop(ind_Rank); % 重新排列种群
end
