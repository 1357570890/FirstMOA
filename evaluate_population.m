function evaluate_population(objs, trueFront, outputFileName)
    % EVALUATE_POPULATION 评估当前种群与真实帕累托前沿的表现
    %
    % 输入:
    %   objs - 当前种群的目标值 (N x M 矩阵)
    %   trueFront - 真实帕累托前沿 (P x M 矩阵)
    %   outputFileName - 输出的 Excel 文件名 (字符串)
    
    % 检查输入维度是否一致
    if size(objs, 2) ~= size(trueFront, 2)
        error('objs 和 trueFront 的目标维度不一致');
    end

    % 获取目标维度 M
    M = size(trueFront, 2);

    % 确保至少有两个目标维度
    if M < 2
        error('至少需要两个目标维度进行多目标评估');
    end

    % 计算参考点，确保其位于所有解和真实前沿的“劣势”方向
    refPoint = max([objs; trueFront], [], 1) + 1;
    
    % 计算各个评价指标
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
    
    % 显示评价指标
    fprintf('超体积 (HV): %.4f\n', hv);
    fprintf('均匀性: %.4f\n', uniformity);
    fprintf('平均距离 (Average Distance): %.5f\n', avgDistance);
    fprintf('逆向世代距离 (IGD): %.5f\n', igd);
    fprintf('目标函数的标准差: ');
    disp(stdObjs);
    fprintf('非支配个体数量: %d\n', numNonDominated);
    fprintf('目标函数的均值: ');
    disp(meanObjs);
    fprintf('目标函数的最大值: ');
    disp(maxObjs);
    fprintf('目标函数的最小值: ');
    disp(minObjs);
    fprintf('覆盖度: %.5f\n', coverage);
    fprintf('分布度 (Spread): %.4f\n', spread);
    fprintf('R2 指标: %.5f\n', r2);
    
    % 将结果保存到 Excel 文件
    % 创建一个单元格数组来存储所有结果
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
    
    % 将结果转换为表格
    resultsTable = cell2table(results, 'VariableNames', {'Metric', 'Value'});
    
    % 生成新的工作表名称
    newSheetName = ['Evaluation_' datestr(now, 'yyyymmdd_HHMMSS')]; % 使用当前时间戳作为工作表名称
    
    % 写入 Excel 文件的新工作表
    % 移除 'WriteMode' 参数
    writetable(resultsTable, outputFileName, 'Sheet', newSheetName, 'WriteRowNames', true);
end

% ====================== 本地函数 ======================

function hv = HV(objs, ~, refPoint)
    % HV 计算超体积 (仅支持二维目标空间)
    %
    % 输入:
    %   objs - 种群的目标值 (N x 2 矩阵)
    %   trueFront - 真实帕累托前沿 (P x 2 矩阵)
    %   refPoint - 参考点 (1 x 2 向量)
    %
    % 输出:
    %   hv - 超体积值

    if size(objs, 2) ~= 2
        error('超体积 (HV) 计算仅支持二维目标空间。当前目标维度: %d', size(objs, 2));
    end

    % 获取非支配解
    ndIndices = findNonDominatedIndices(objs);
    ndObjs = objs(ndIndices, :);

    if isempty(ndObjs)
        hv = 0;
        return;
    end

    % 按第一个目标升序排序
    sortedObjs = sortrows(ndObjs, 1, 'ascend');

    % 初始化超体积
    hv = 0;
    previous_x = sortedObjs(1,1);

    for i = 1:size(sortedObjs, 1)
        width = sortedObjs(i, 1) - previous_x;
        height = refPoint(2) - sortedObjs(i, 2);
        width = max(width, 0);  % 确保宽度非负
        height = max(height, 0); % 确保高度非负
        hv = hv + width * height;
        previous_x = sortedObjs(i, 1);
    end

    % 计算最后一个区间到参考点
    last_width = refPoint(1) - sortedObjs(end, 1);
    last_height = refPoint(2) - sortedObjs(end, 2);
    last_width = max(last_width, 0);  % 确保宽度非负
    last_height = max(last_height, 0); % 确保高度非负
    hv = hv + last_width * last_height;
end

function uniformity = Uniformity(objs)
    % Uniformity 计算种群的均匀性
    %
    % 输入:
    %   objs - 种群的目标值 (N x M 矩阵)
    %
    % 输出:
    %   uniformity - 均匀性指标

    distances = pdist2(objs, objs); % N x N 距离矩阵
    N = size(objs, 1);
    distances(1:N+1:end) = NaN; % 排除自身距离
    meanDistance = nanmean(distances(:)); % 计算平均距离
    uniformity = 1 / meanDistance; % 均匀性为平均距离的倒数
end

function avgDistance = AverageDistance(objs, trueFront)
    % AverageDistance 计算种群到真实前沿的平均最小距离
    %
    % 输入:
    %   objs - 种群的目标值 (N x M 矩阵)
    %   trueFront - 真实帕累托前沿 (P x M 矩阵)
    %
    % 输出:
    %   avgDistance - 平均距离

    distances = pdist2(objs, trueFront); % N x P 距离矩阵
    minDistances = min(distances, [], 2); % 每个个体到最近真实前沿点的距离
    avgDistance = mean(minDistances);
end

function igd = IGD(objs, trueFront)
    % IGD 计算逆向世代距离
    %
    % 输入:
    %   objs - 种群的目标值 (N x M 矩阵)
    %   trueFront - 真实帕累托前沿 (P x M 矩阵)
    %
    % 输出:
    %   igd - 逆向世代距离

    distances = pdist2(trueFront, objs); % P x N 距离矩阵
    minDistances = min(distances, [], 2); % 每个真实前沿点到最近种群个体的距离
    igd = mean(minDistances);
end

function spread = Spread(objs, trueFront)
    % Spread 计算种群的分布度
    %
    % 输入:
    %   objs - 种群的目标值 (N x M 矩阵)
    %   trueFront - 真实帕累托前沿 (P x M 矩阵)
    %
    % 输出:
    %   spread - 分布度指标

    ndObjs = objs(findNonDominatedIndices(objs), :);
    sortedObjs = sortrows(ndObjs, 1, 'ascend');
    numNd = size(sortedObjs, 1);

    if numNd < 2
        spread = 0;
        return;
    end

    % 计算边界点到真实前沿的最小距离
    d1 = min(pdist2(sortedObjs(1, :), trueFront));
    d2 = min(pdist2(sortedObjs(end, :), trueFront));

    % 计算相邻解之间的距离
    d = pdist(sortedObjs, 'euclidean');
    d_avg = mean(d);

    % 计算分布度
    spread = (d1 + d2 + sum(abs(d - d_avg))) / (d1 + d2 + 2 * (numNd - 1) * d_avg);
end

function ndIndices = findNonDominatedIndices(objs)
    % findNonDominatedIndices 找到非支配个体的索引
    %
    % 输入:
    %   objs - 种群的目标值 (N x M 矩阵)
    %
    % 输出:
    %   ndIndices - 非支配个体的索引向量

    N = size(objs, 1);
    nd = true(N, 1);
    for i = 1:N
        if nd(i)
            % 找到所有支配第i个个体的个体
            dominated = all(objs <= objs(i, :), 2) & any(objs < objs(i, :), 2);
            dominated(i) = false; % 排除自身
            if any(dominated)
                nd(i) = false;
            end
        end
    end
    ndIndices = find(nd);
end

function coverage = Coverage(objs, trueFront)
    % Coverage 计算覆盖度
    %
    % 输入:
    %   objs - 种群的目标值 (N x M 矩阵)
    %   trueFront - 真实帕累托前沿 (P x M 矩阵)
    %
    % 输出:
    %   coverage - 覆盖度指标

    distances = pdist2(objs, trueFront); % N x P 距离矩阵
    minDistances = min(distances, [], 2); % 每个个体到最近真实前沿点的距离
    coverage = mean(minDistances);
end

function r2 = R2(objs, trueFront)
    % R2 计算R2指标
    %
    % 输入:
    %   objs - 种群的目标值 (N x M 矩阵)
    %   trueFront - 真实帕累托前沿 (P x M 矩阵)
    %
    % 输出:
    %   r2 - R2指标

    refPoints = trueFront;
    r2 = 0;
    for i = 1:size(refPoints,1)
        distances = pdist2(objs, refPoints(i, :), 'euclidean');
        minDist = min(distances);
        r2 = r2 + minDist;
    end
    r2 = r2 / size(refPoints,1);
end