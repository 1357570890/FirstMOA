clc; clear; close all
drawing_flag = 1;  % 是否绘制结果

% 选择测试函数
testFunctionName = 'ZDT3'; % 可以更改为 'ZDT2' 或 'ZDT3'

% 获取目标函数和真实帕累托前沿数据
[objectiveFunction, paretoData] = getTestFunction(testFunctionName);

% 初始化参数
nPop = 150;       % 種群大小
nVar = 10;        % 決策變量數量
xmin = 0;         % 決策變量下界
xmax = 1;         % 決策變量上界
maxIt = 200;      % 最大迭代次數
Pc = 0.9;         % 交叉概率
Pr = 0.1;         % 重複概率
Pm = 0.3;         % 變異概率
lengthToCopy = 2; % 選擇重複交叉的長度

% 調整種群計數
[nPc, nPr, nPm] = adjustPopulationCounts(nPop, Pc, Pr, Pm);

% 結果存儲結構
template.Arg = [];
template.Obj = [];
template.DominantSet = [];
template.Dominated = 0;
template.Rank = [];
template.CrowdingDistance = [];

% 初始化種群
pop = repmat(template, nPop, 1);

% 初始化種群個體部分
r = 3.9;          % Logistic 映射的參數，通常在3.57到4之間
burn_in = 100;    % 熱身期，用於去除初始非混沌行為
x0_base = 0.5;    % 基礎初始值，推薦接近0.5

% 使用改進的初始化函數生成種群
pop = initialize_population(r, x0_base, nPop, nVar, xmin, xmax, objectiveFunction, burn_in);

% 進行初始的非支配排序和擁擠度計算
[pop, F] = Non_Dominate_Sort(pop);
pop = Cal_crowdingdistance(pop, F); % 計算擁擠度

% 保存檔案
Arc = Savearchive(pop);

% 迭代過程
for it = 1:maxIt
    
    % 調整種群到垃圾中心
    if it > maxIt / 4
        pop = AdjustPopulationToGarbageCenter(pop, Arc, xmin, xmax);
    end
    
    % 根據當前種群和檔案調整種群
    if it ~= 1
        a = 2 - it * (2 / maxIt); % 計算參數 a
        pop = AdjustPopulation(pop, Arc, a, xmin, xmax); % 調整種群
    end
    
    % 交叉操作
    popc = Cross(pop, Pc, nVar, xmin, xmax, objectiveFunction, nPc);
    
    % 變異操作
    popm = MutatePop(pop, Pm, xmin, xmax, objectiveFunction, nPm);
    
    % 重複操作
    popr = RepeatCrossOperation(pop, Pr, xmin, xmax, objectiveFunction, lengthToCopy, nPr);
    
    % 合併新種群
    newpop = [pop; popc; popr; popm];
    
    % 非支配排序
    [newpop, F] = Non_Dominate_Sort(newpop);
    newpop = Cal_crowdingdistance(newpop, F); % 計算擁擠度
    
    % 保存檔案
    Arc = Savearchive(newpop);  
    
    % 隨機丟棄個體
    newpop = lostrand(newpop, nPop, it, maxIt);
    
    % 選擇前nPop個體作為新的種群
    pop = Selection(newpop, nPop);
    
    % 對當前種群進行非支配排序和擁擠度計算
    [pop, F] = Non_Dominate_Sort(pop);
    pop = Cal_crowdingdistance(pop, F);
    pop = Multi_Sort(pop);
    
    % 獲取當前種群的目標函數值
    Objs = reshape([pop.Obj], [], size(pop(1).Obj, 1))';
    
    % 計算非支配個體數量
    numNonDominated = length(F{1});
    
    % 計算目標函數值的標準差
    stdObjs = std(Objs, 0, 2);
    
    % 繪製當前種群的目標函數值
    if drawing_flag
        plot_population(Objs);
        hold on;
    end
end

% 繪製真實的帕累托前沿數據
hold on; % 保持當前圖形
plot(paretoData.PF(:, 1), paretoData.PF(:, 2), 'bo', 'MarkerSize', 8, 'DisplayName', 'True Pareto Front'); % 繪製真實帕累托前沿
legend show; % 顯示圖例

% 評估當前種群的表現
Objs = reshape([pop.Obj], [], size(pop(1).Obj, 1))';
evaluate_population(Objs, paretoData.PF, 'evaluation_results.xlsx'); % PF 是 P x M