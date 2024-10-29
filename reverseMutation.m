function newState = reverseDefection(currentState)
    % reverseDefection ��ת���Ժ���
    % ����:
    %   currentState - ��ǰ����״̬ (0 �� 1)
    % ���:
    %   newState - ��ת��Ĳ���״̬ (0 �� 1)

    % ��������Ƿ�Ϊ��Ч״̬
    if currentState ~= 0 && currentState ~= 1
        error('��ǰ״̬������0��1��������Ч');
    end

    % ��ת����
    newState = 1 - currentState; % 0 ��Ϊ 1��1 ��Ϊ 0
end
