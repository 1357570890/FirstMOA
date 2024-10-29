function offspring = RepeatCross(p, xmin, xmax, lengthToCopy)
    n = numel(p); % ��ȡ��ǰ�����ά������
    offspring = p; % ��ʼ�����Ϊ��ǰ����

    % ���ѡ����ʼ����
    startIdx = randi([1, n-1]); % ���ѡ����ʼλ�ã�ȷ�����㹻�Ŀռ���и���

    % ��鸴�Ƴ����Ƿ񳬳���Χ
    if startIdx + lengthToCopy - 1 > n
        lengthToCopy = n - startIdx; % �������Ƴ�������Ӧ�߽�
    end

    % ���ѡ���Ʒ���
    if rand() < 0.5
        % ����ʼλ�������
        offspring(startIdx:startIdx + lengthToCopy - 1) = p(startIdx:startIdx + lengthToCopy - 1);
    else
        % ����ʼλ����ǰ����
        if startIdx - lengthToCopy + 1 < 1
            % �����ʼλ�ò�������ǰ���ƣ�������ʼλ��
            startIdx = lengthToCopy; % ȷ����ʼλ������Ч��Χ��
        end
        offspring(startIdx - lengthToCopy + 1:startIdx) = p(startIdx:startIdx + lengthToCopy - 1);
    end

    % ȷ�������ֵ�� [xmin, xmax] ��Χ��
    offspring = max(min(offspring, xmax), xmin);
end
