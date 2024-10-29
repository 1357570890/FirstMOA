% 生成真实帕累托前沿数据并保存为 .mat 文件

% 生成真实帕累托前沿的目标值
% 真实帕累托前沿的点是由两个目标函数组成的
f1 = linspace(0, 1, 100);  % 目标函数 f1 的值
f2 = 1 - f1.^2;            % 目标函数 f2 的值

% 将目标值组合成一个 N x 2 的矩阵
trueFront = [f1', f2'];  % 将 f1 和 f2 组合成一个矩阵

% 保存数据到 .mat 文件
save('true_pareto_front.mat', 'trueFront');

% 输出提示信息
disp('真实帕累托前沿数据已成功生成并保存到 true_pareto_front.mat');
