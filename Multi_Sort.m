function pop = Multi_Sort(pop)
    % ����ӵ���Ƚ��н�������
    [~, ind_cd] = sort([pop.CrowdingDistance], 'descend'); % ����ӵ���Ƚ�������
    pop = pop(ind_cd); % ����������Ⱥ

    % ���ݵȼ�������������
    [~, ind_Rank] = sort([pop.Rank], 'ascend'); % ���յȼ���������
    pop = pop(ind_Rank); % ����������Ⱥ
end
