function distance = Cal_distance(Individual1, Individual2)
    % ������������֮���ŷ����þ���
    if size(Individual1) ~= size(Individual2)
        error('����ĸ�����������ͬ��ά��');
    end
    
    % ��ʼ������Ϊ0
    distance = 0;
    
    % ����ÿ��ά�ȵĲ�ֵ��ƽ����
    for i = 1:length(Individual1)
        distance = distance + (Individual1(i) - Individual2(i))^2; % �ۼ�ÿ��ά�ȵĲ��ƽ��
    end
    
    % ȡƽ���͵�ƽ�������õ�ŷ����þ���
    distance = sqrt(distance);
end
