function centroid = FindCentroid(p)
    n = length(p(2).Arg); % ��ȡ��Ⱥ�и��������
    m = length(p(2).Arg(1).Arg);  % ��ȡÿ������ľ��߱�������
    
    % ��ʼ������
    centroid = zeros(1, m); 

    % ��������
    for i = 1:n
        centroid = centroid + p(2).Arg(i).Arg; % �ۼ�ÿ������ľ��߱���
    end
    centroid = centroid / n; % �������ģ����ۼӺͳ��Ը�������

end
