clc; clear; close all
drawing_flag = 1;  % �Ƿ���ƽ��

% ѡ����Ժ���
testFunctionName = 'ZDT3'; % ���Ը���Ϊ 'ZDT2' �� 'ZDT3'

% ��ȡĿ�꺯������ʵ������ǰ������
[objectiveFunction, paretoData] = getTestFunction(testFunctionName);

% ��ʼ������
nPop = 150;       % �NȺ��С
nVar = 10;        % �Q��׃������
xmin = 0;         % �Q��׃���½�
xmax = 1;         % �Q��׃���Ͻ�
maxIt = 200;      % �������Δ�
Pc = 0.9;         % �������
Pr = 0.1;         % ���}����
Pm = 0.3;         % ׃������
lengthToCopy = 2; % �x�����}������L��

% �{���NȺӋ��
[nPc, nPr, nPm] = adjustPopulationCounts(nPop, Pc, Pr, Pm);

% �Y���惦�Y��
template.Arg = [];
template.Obj = [];
template.DominantSet = [];
template.Dominated = 0;
template.Rank = [];
template.CrowdingDistance = [];

% ��ʼ���NȺ
pop = repmat(template, nPop, 1);

% ��ʼ���NȺ���w����
r = 3.9;          % Logistic ӳ��ą�����ͨ����3.57��4֮�g
burn_in = 100;    % �����ڣ����ȥ����ʼ�ǻ����О�
x0_base = 0.5;    % ���A��ʼֵ�����]�ӽ�0.5

% ʹ�ø��M�ĳ�ʼ���������ɷNȺ
pop = initialize_population(r, x0_base, nPop, nVar, xmin, xmax, objectiveFunction, burn_in);

% �M�г�ʼ�ķ�֧������͓�D��Ӌ��
[pop, F] = Non_Dominate_Sort(pop);
pop = Cal_crowdingdistance(pop, F); % Ӌ���D��

% ����n��
Arc = Savearchive(pop);

% �����^��
for it = 1:maxIt
    
    % �{���NȺ����������
    if it > maxIt / 4
        pop = AdjustPopulationToGarbageCenter(pop, Arc, xmin, xmax);
    end
    
    % ������ǰ�NȺ�͙n���{���NȺ
    if it ~= 1
        a = 2 - it * (2 / maxIt); % Ӌ�ㅢ�� a
        pop = AdjustPopulation(pop, Arc, a, xmin, xmax); % �{���NȺ
    end
    
    % �������
    popc = Cross(pop, Pc, nVar, xmin, xmax, objectiveFunction, nPc);
    
    % ׃������
    popm = MutatePop(pop, Pm, xmin, xmax, objectiveFunction, nPm);
    
    % ���}����
    popr = RepeatCrossOperation(pop, Pr, xmin, xmax, objectiveFunction, lengthToCopy, nPr);
    
    % �ρ��·NȺ
    newpop = [pop; popc; popr; popm];
    
    % ��֧������
    [newpop, F] = Non_Dominate_Sort(newpop);
    newpop = Cal_crowdingdistance(newpop, F); % Ӌ���D��
    
    % ����n��
    Arc = Savearchive(newpop);  
    
    % �S�C�G�����w
    newpop = lostrand(newpop, nPop, it, maxIt);
    
    % �x��ǰnPop���w�����µķNȺ
    pop = Selection(newpop, nPop);
    
    % ����ǰ�NȺ�M�з�֧������͓�D��Ӌ��
    [pop, F] = Non_Dominate_Sort(pop);
    pop = Cal_crowdingdistance(pop, F);
    pop = Multi_Sort(pop);
    
    % �@ȡ��ǰ�NȺ��Ŀ�˺���ֵ
    Objs = reshape([pop.Obj], [], size(pop(1).Obj, 1))';
    
    % Ӌ���֧�䂀�w����
    numNonDominated = length(F{1});
    
    % Ӌ��Ŀ�˺���ֵ�Ę˜ʲ�
    stdObjs = std(Objs, 0, 2);
    
    % �L�u��ǰ�NȺ��Ŀ�˺���ֵ
    if drawing_flag
        plot_population(Objs);
        hold on;
    end
end

% �L�u�挍��������ǰ�ؔ���
hold on; % ���֮�ǰ�D��
plot(paretoData.PF(:, 1), paretoData.PF(:, 2), 'bo', 'MarkerSize', 8, 'DisplayName', 'True Pareto Front'); % �L�u�挍������ǰ��
legend show; % �@ʾ�D��

% �u����ǰ�NȺ�ı�F
Objs = reshape([pop.Obj], [], size(pop(1).Obj, 1))';
evaluate_population(Objs, paretoData.PF, 'evaluation_results.xlsx'); % PF �� P x M