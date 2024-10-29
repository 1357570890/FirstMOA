function population = AdjustPopulation(pop, arc, a, minValue, maxValue)
    nVar = length(pop(1).Arg);
    
    % ��ȡ Rank ���� 1 �ĸ���
    rank1_individuals = arc(1).Arg([arc(1).Arg.Rank] == 1);
    
    % ��� Rank 1 �ĸ����������� 3
    if length(rank1_individuals) > 3
        % ���ѡ�� 3 ������
        selected_individuals = rank1_individuals(randperm(length(rank1_individuals), 3));
    else
        % �����������С�ڵ��� 3��ѡ������ Rank 1 �ĸ���
        selected_individuals = rank1_individuals;
        
        % ��� Rank 1 �ĸ�������С�� 2��ѡ�� Rank 2 �ĸ���
        if length(selected_individuals) < 2
            rank2_individuals = arc(1).Arg([arc(1).Arg.Rank] == 2);
            selected_individuals = [selected_individuals; rank2_individuals]; % ׷��
        end
        
        % �������������ȻС�� 2��ѡ�� Rank 3 �ĸ���
        if length(selected_individuals) < 2
            rank3_individuals = arc(1).Arg([arc(1).Arg.Rank] == 3);
            selected_individuals = [selected_individuals; rank3_individuals]; % ׷��
        end
    end

    % ѡ����������
    Delta = selected_individuals(1);
    Beta = selected_individuals(2);
    Alpha = selected_individuals(3);

    for i = 1:length(pop)
        % ���������
        c = 2 .* rand(1, nVar);  % �������ϵ��
        
        % ���� Delta ����ĸ���λ��
        D = abs(c .* Delta.Arg - pop(i).Arg);
        A = 2 .* a .* rand(1, nVar) - a;
        X1 = Delta.Arg - A .* abs(D);
        
        % ���� Beta ����ĸ���λ��
        c = 2 .* rand(1, nVar);  % �������ϵ��
        D = abs(c .* Beta.Arg - pop(i).Arg);  % �����ֵ
        A = 2 .* a .* rand(1, nVar) - a;  % �������ϵ��
        X2 = Beta.Arg - A .* abs(D);  % �������λ�� X2
        
        % ���� Alpha ����ĸ���λ��
        c = 2 .* rand(1, nVar);  % �������ϵ��
        D = abs(c .* Alpha.Arg - pop(i).Arg);  % �����ֵ
        A = 2 .* a .* rand(1, nVar) - a;  % �������ϵ��
        X3 = Alpha.Arg - A .* abs(D);  % �������λ�� X3
        
        % ���µ�ǰ�����λ��
        k1 = 1;
        k2 = 1;
        k3 = 1;
        newArg = (k1 * X1 + k2 * X2 + k3 * X3) ./ 3;
        
        % ����µľ��߱����Ƿ���ָ����Χ��
        if all(newArg >= minValue) && all(newArg <= maxValue)
            % ���¸���ľ��߱���
            pop(i).Arg = newArg;  
        end
    end
    
    % ���ظ��º����Ⱥ
    population = pop;
end
