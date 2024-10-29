function [isInRange, outOfRangeIndices] = checkRange(minValue, maxValue, arr)
    % ��������е�Ԫ���Ƿ���ָ����Χ��
    % minValue: ��Сֵ
    % maxValue: ���ֵ
    % arr: ��������
    % isInRange: ����ֵ��ָʾ�Ƿ�����Ԫ�ض���ָ����Χ��
    % outOfRangeIndices: ������Χ��Ԫ�ص�����

    % �ҵ�������Χ��Ԫ�ص�����
    outOfRangeIndices = find(arr < minValue | arr > maxValue);
    
    % ���û�г�����Χ��Ԫ�أ��򷵻� true �Ϳ�����
    if isempty(outOfRangeIndices)
        isInRange = true; % ����Ԫ�ض��ڷ�Χ��
        outOfRangeIndices = []; % ������
    else
        isInRange = false; % ���ڳ�����Χ��Ԫ��
    end
end
