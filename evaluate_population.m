function evaluate_population(objs, trueFront, outputFileName)
    % EVALUATE_POPULATION ������ǰ��Ⱥ����ʵ������ǰ�صı���
    %
    % ����:
    %   objs - ��ǰ��Ⱥ��Ŀ��ֵ (N x M ����)
    %   trueFront - ��ʵ������ǰ�� (P x M ����)
    %   outputFileName - ����� Excel �ļ��� (�ַ���)
    
    % �������ά���Ƿ�һ��
    if size(objs, 2) ~= size(trueFront, 2)
        error('objs �� trueFront ��Ŀ��ά�Ȳ�һ��');
    end

    % ��ȡĿ��ά�� M
    M = size(trueFront, 2);

    % ȷ������������Ŀ��ά��
    if M < 2
        error('������Ҫ����Ŀ��ά�Ƚ��ж�Ŀ������');
    end

    % ����ο��㣬ȷ����λ�����н����ʵǰ�صġ����ơ�����
    refPoint = max([objs; trueFront], [], 1) + 1;
    
    % �����������ָ��
    hv = HV(objs, trueFront, refPoint);
    uniformity = Uniformity(objs);
    avgDistance = AverageDistance(objs, trueFront);
    igd = IGD(objs, trueFront);
    stdObjs = std(objs, 0, 1);
    numNonDominated = length(findNonDominatedIndices(objs));
    meanObjs = mean(objs, 1);
    maxObjs = max(objs, [], 1);
    minObjs = min(objs, [], 1);
    coverage = Coverage(objs, trueFront);
    spread = Spread(objs, trueFront);
    r2 = R2(objs, trueFront);
    
    % ��ʾ����ָ��
    fprintf('����� (HV): %.4f\n', hv);
    fprintf('������: %.4f\n', uniformity);
    fprintf('ƽ������ (Average Distance): %.5f\n', avgDistance);
    fprintf('������������ (IGD): %.5f\n', igd);
    fprintf('Ŀ�꺯���ı�׼��: ');
    disp(stdObjs);
    fprintf('��֧���������: %d\n', numNonDominated);
    fprintf('Ŀ�꺯���ľ�ֵ: ');
    disp(meanObjs);
    fprintf('Ŀ�꺯�������ֵ: ');
    disp(maxObjs);
    fprintf('Ŀ�꺯������Сֵ: ');
    disp(minObjs);
    fprintf('���Ƕ�: %.5f\n', coverage);
    fprintf('�ֲ��� (Spread): %.4f\n', spread);
    fprintf('R2 ָ��: %.5f\n', r2);
    
    % ��������浽 Excel �ļ�
    % ����һ����Ԫ���������洢���н��
    results = {
        'Hypervolume (HV)', hv;
        'Uniformity', uniformity;
        'Average Distance', avgDistance;
        'Inverse Generational Distance (IGD)', igd;
        'Standard Deviation', stdObjs;
        'Number of Non-dominated Individuals', numNonDominated;
        'Mean Objectives', meanObjs;
        'Max Objectives', maxObjs;
        'Min Objectives', minObjs;
        'Coverage', coverage;
        'Spread', spread;
        'R2 Metric', r2
    };
    
    % �����ת��Ϊ���
    resultsTable = cell2table(results, 'VariableNames', {'Metric', 'Value'});
    
    % �����µĹ���������
    newSheetName = ['Evaluation_' datestr(now, 'yyyymmdd_HHMMSS')]; % ʹ�õ�ǰʱ�����Ϊ����������
    
    % д�� Excel �ļ����¹�����
    % �Ƴ� 'WriteMode' ����
    writetable(resultsTable, outputFileName, 'Sheet', newSheetName, 'WriteRowNames', true);
end

% ====================== ���غ��� ======================

function hv = HV(objs, ~, refPoint)
    % HV ���㳬��� (��֧�ֶ�άĿ��ռ�)
    %
    % ����:
    %   objs - ��Ⱥ��Ŀ��ֵ (N x 2 ����)
    %   trueFront - ��ʵ������ǰ�� (P x 2 ����)
    %   refPoint - �ο��� (1 x 2 ����)
    %
    % ���:
    %   hv - �����ֵ

    if size(objs, 2) ~= 2
        error('����� (HV) �����֧�ֶ�άĿ��ռ䡣��ǰĿ��ά��: %d', size(objs, 2));
    end

    % ��ȡ��֧���
    ndIndices = findNonDominatedIndices(objs);
    ndObjs = objs(ndIndices, :);

    if isempty(ndObjs)
        hv = 0;
        return;
    end

    % ����һ��Ŀ����������
    sortedObjs = sortrows(ndObjs, 1, 'ascend');

    % ��ʼ�������
    hv = 0;
    previous_x = sortedObjs(1,1);

    for i = 1:size(sortedObjs, 1)
        width = sortedObjs(i, 1) - previous_x;
        height = refPoint(2) - sortedObjs(i, 2);
        width = max(width, 0);  % ȷ����ȷǸ�
        height = max(height, 0); % ȷ���߶ȷǸ�
        hv = hv + width * height;
        previous_x = sortedObjs(i, 1);
    end

    % �������һ�����䵽�ο���
    last_width = refPoint(1) - sortedObjs(end, 1);
    last_height = refPoint(2) - sortedObjs(end, 2);
    last_width = max(last_width, 0);  % ȷ����ȷǸ�
    last_height = max(last_height, 0); % ȷ���߶ȷǸ�
    hv = hv + last_width * last_height;
end

function uniformity = Uniformity(objs)
    % Uniformity ������Ⱥ�ľ�����
    %
    % ����:
    %   objs - ��Ⱥ��Ŀ��ֵ (N x M ����)
    %
    % ���:
    %   uniformity - ������ָ��

    distances = pdist2(objs, objs); % N x N �������
    N = size(objs, 1);
    distances(1:N+1:end) = NaN; % �ų��������
    meanDistance = nanmean(distances(:)); % ����ƽ������
    uniformity = 1 / meanDistance; % ������Ϊƽ������ĵ���
end

function avgDistance = AverageDistance(objs, trueFront)
    % AverageDistance ������Ⱥ����ʵǰ�ص�ƽ����С����
    %
    % ����:
    %   objs - ��Ⱥ��Ŀ��ֵ (N x M ����)
    %   trueFront - ��ʵ������ǰ�� (P x M ����)
    %
    % ���:
    %   avgDistance - ƽ������

    distances = pdist2(objs, trueFront); % N x P �������
    minDistances = min(distances, [], 2); % ÿ�����嵽�����ʵǰ�ص�ľ���
    avgDistance = mean(minDistances);
end

function igd = IGD(objs, trueFront)
    % IGD ����������������
    %
    % ����:
    %   objs - ��Ⱥ��Ŀ��ֵ (N x M ����)
    %   trueFront - ��ʵ������ǰ�� (P x M ����)
    %
    % ���:
    %   igd - ������������

    distances = pdist2(trueFront, objs); % P x N �������
    minDistances = min(distances, [], 2); % ÿ����ʵǰ�ص㵽�����Ⱥ����ľ���
    igd = mean(minDistances);
end

function spread = Spread(objs, trueFront)
    % Spread ������Ⱥ�ķֲ���
    %
    % ����:
    %   objs - ��Ⱥ��Ŀ��ֵ (N x M ����)
    %   trueFront - ��ʵ������ǰ�� (P x M ����)
    %
    % ���:
    %   spread - �ֲ���ָ��

    ndObjs = objs(findNonDominatedIndices(objs), :);
    sortedObjs = sortrows(ndObjs, 1, 'ascend');
    numNd = size(sortedObjs, 1);

    if numNd < 2
        spread = 0;
        return;
    end

    % ����߽�㵽��ʵǰ�ص���С����
    d1 = min(pdist2(sortedObjs(1, :), trueFront));
    d2 = min(pdist2(sortedObjs(end, :), trueFront));

    % �������ڽ�֮��ľ���
    d = pdist(sortedObjs, 'euclidean');
    d_avg = mean(d);

    % ����ֲ���
    spread = (d1 + d2 + sum(abs(d - d_avg))) / (d1 + d2 + 2 * (numNd - 1) * d_avg);
end

function ndIndices = findNonDominatedIndices(objs)
    % findNonDominatedIndices �ҵ���֧����������
    %
    % ����:
    %   objs - ��Ⱥ��Ŀ��ֵ (N x M ����)
    %
    % ���:
    %   ndIndices - ��֧��������������

    N = size(objs, 1);
    nd = true(N, 1);
    for i = 1:N
        if nd(i)
            % �ҵ�����֧���i������ĸ���
            dominated = all(objs <= objs(i, :), 2) & any(objs < objs(i, :), 2);
            dominated(i) = false; % �ų�����
            if any(dominated)
                nd(i) = false;
            end
        end
    end
    ndIndices = find(nd);
end

function coverage = Coverage(objs, trueFront)
    % Coverage ���㸲�Ƕ�
    %
    % ����:
    %   objs - ��Ⱥ��Ŀ��ֵ (N x M ����)
    %   trueFront - ��ʵ������ǰ�� (P x M ����)
    %
    % ���:
    %   coverage - ���Ƕ�ָ��

    distances = pdist2(objs, trueFront); % N x P �������
    minDistances = min(distances, [], 2); % ÿ�����嵽�����ʵǰ�ص�ľ���
    coverage = mean(minDistances);
end

function r2 = R2(objs, trueFront)
    % R2 ����R2ָ��
    %
    % ����:
    %   objs - ��Ⱥ��Ŀ��ֵ (N x M ����)
    %   trueFront - ��ʵ������ǰ�� (P x M ����)
    %
    % ���:
    %   r2 - R2ָ��

    refPoints = trueFront;
    r2 = 0;
    for i = 1:size(refPoints,1)
        distances = pdist2(objs, refPoints(i, :), 'euclidean');
        minDist = min(distances);
        r2 = r2 + minDist;
    end
    r2 = r2 / size(refPoints,1);
end