function population = Savearchive(p)

    set_maxRank = 20; % ������� Rank �ĸ�������
    set_maxarc = 20;  % �������浵��������
    set_max = 1; 

    n = size(p, 1);
    
    % ��ȡ��� Rank
    maxRank = max([p.Rank]);  % ��ȡ���������� Rank ֵ
    
    % ��ʼ���浵�ṹ��
    population = repmat(struct('Arg', []), 2, 1);  
    
    % �洢 Rank Ϊ 1��2 �� 3 �ĸ��嵽 population(1).Arg
    bestIndividuals = p([p.Rank] == 1);
    secondBestIndividuals = p([p.Rank] == 2);
    thirdBestIndividuals = p([p.Rank] == 3);
    
    % �ϲ���Ѹ���
    population(1).Arg = [bestIndividuals; secondBestIndividuals; thirdBestIndividuals];   % �洢��Ѹ���

    % �洢 Rank �ϲ�ĸ���
    if maxRank > set_maxRank
        worstIndividuals = p(end-set_maxarc-1:end); % ֱ��ʹ�� p �е���󼸸�����
    else
        worstIndividuals = p([p.Rank] == maxRank); % �洢��ǰ��� Rank �ĸ���
        
        % ��������������� 5����ȡ��� 15 ������
        if length(worstIndividuals) < 5
            worstIndividuals = p(end-14:end);
        end
    end
    
    population(2).Arg = worstIndividuals; % �洢 Rank �ϲ�ĸ��嵽 population(2).Arg
    
end
