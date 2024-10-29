function pop = initialize_population(r, x0_base, nPop, nVar, xmin, xmax, objectiveFunction, burn_in)
    % initialize_population ��ʼ����Ⱥ
    % r: Logisticӳ��Ĳ���
    % x0_base: ������ʼֵ
    % nPop: ��Ⱥ��С
    % nVar: ���߱�������
    % xmin, xmax: ���߱�����Χ
    % objectiveFunction: Ŀ�꺯�����
    % burn_in: �����ڣ�ȥ��ǰburn_in��ֵ

    % ����ͨ��Logisticӳ�����Ⱥ����
    population = logistic_map_population(r, x0_base, nPop, nVar, burn_in);
    
    % ������Ⱥ�ṹģ��
    template.Arg = [];
    template.Obj = [];
    template.DominantSet = [];
    template.Dominated = 0;
    template.Rank = [];
    template.CrowdingDistance = [];
    
    % ��ʼ����Ⱥ
    pop = repmat(template, nPop, 1);
    
    for i = 1:nPop
        % �����ɵ�ֵ���ŵ�[xmin, xmax]��Χ��
        pop(i).Arg = xmin + (xmax - xmin) * population(i, :);
        pop(i).Obj = objectiveFunction(pop(i).Arg);
    end
end