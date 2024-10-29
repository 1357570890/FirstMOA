function population = AdjustPopulationToGarbageCenter(pop, arc, minValue, maxValue)
    % ������Ⱥ��Զ����������
    % pop: ��ǰ��Ⱥ
    % arc: �洢��ʷ����ĵ���
    % minValue: ���߱�������Сֵ
    % maxValue: ���߱��������ֵ

    ratio = 0.01; % ��������
    mindistance = 0.1; % ��С������ֵ

    % �����������ģ���ʷ��������ģ�
    garbage_center = FindCentroid(arc);
    
    % ������Ⱥ�е�ÿ������
    for i = 1:length(pop)
        % ������ĵȼ�
        if pop(i).Rank ~= 1
            % ����������������ĵľ��������С����
            if Cal_distance(pop(i).Arg, garbage_center) > mindistance
                % �����µľ��߱���
                newArg = pop(i).Arg - ratio * garbage_center;  
                
                % ����µľ��߱����Ƿ���ָ����Χ��
                if all(newArg >= minValue) && all(newArg <= maxValue)
                    % ���¸���ľ��߱���
                    pop(i).Arg = newArg;  
                end
            end
        end
    end
    
    population = pop; % ���ص��������Ⱥ
end