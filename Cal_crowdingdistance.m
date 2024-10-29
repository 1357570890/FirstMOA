function pop = Cal_crowdingdistance(pop, F)
    % ������Ⱥ�и����ӵ����
    % pop: ��ǰ��Ⱥ
    % F: ��֧������ĸ�������

    nF = numel(F); % ��ȡ��֧������ĸ�������
    for k = 1 : nF
        Objs = [pop(F{k}).Obj]; % ��ȡ��ǰ��֧����Ŀ��ֵ
        nObj = size(Objs, 1); % ��ȡĿ�꺯��������
        n = numel(F{k}); % ��ȡ��ǰ��֧���ĸ�������
        d = zeros(n, nObj); % ��ʼ��ӵ���Ⱦ���

        for j = 1 : nObj
            [obj, ind] = sort(Objs(j,:), 'ascend'); % ��Ŀ��ֵ������������
            d(ind(1), j) = inf; % ��Сֵ��ӵ������Ϊ�����
            for i = 2 : n - 1
                % ����ӵ����
                d(ind(i), j) = abs(obj(i+1) - obj(i-1)) / abs(obj(1) - obj(end));
            end
            d(ind(end), j) = inf;  % ���ֵ��ӵ������Ϊ�����
        end

        for i = 1 : n
            % ��ÿ�������ӵ��������Ϊ����Ŀ���ӵ����֮��
            pop(F{k}(i)).CrowdingDistance = sum(d(i, :));
        end
    end
end
