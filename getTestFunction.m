function [objectiveFunction, paretoData] = getTestFunction(testFunctionName)
    switch testFunctionName
        case 'ZDT1'
            objectiveFunction = @ZDT1; 
        case 'ZDT2'
            objectiveFunction = @ZDT2; 
        case 'ZDT3'
            objectiveFunction = @ZDT3; 
        case 'ZDT4'
            objectiveFunction = @ZDT4; 
        case 'ZDT5'
            objectiveFunction = @ZDT5;
        case 'ZDT6'
            objectiveFunction = @ZDT6; 
        otherwise
            error('Unknown test function: %s', testFunctionName);
    end
    % 使用方括号进行字符串拼接
    paretoFileName = ['pareto_' func2str(objectiveFunction) '.mat'];
    paretoData = load(paretoFileName);
end

% ZDT1.m
function y = ZDT1(varargin)
    % 将输入的逗号分隔的数字转换为向量 x
    x = [varargin{:}];  % 将输入的参数合并为一个向量
    dim = length(x);    % 计算维度
    % ZDT1 评估函数
    y1 = x(1);
    su = sum(x) - x(1);    
    g = 1 + 9 * su / (dim - 1);
    y2 = g * (1 - sqrt(x(1) / g));
    % 将 y 变为列向量 [y1; y2]
    y = [y1; y2];
end

% ZDT2.m
function y = ZDT2(varargin)
    % 将输入的逗号分隔的数字转换为向量 x
    x = [varargin{:}];  % 将输入的参数合并为一个向量
    dim = length(x);    % 计算维度
    % ZDT2 评估函数
    y1 = x(1);
    g = 1 + 9 * sum(x(2:dim)) / (dim - 1);
    y2 = g * (1 - (x(1) / g)^2);
    % 将 y 变为列向量 [y1; y2]
    y = [y1; y2];
end

% ZDT3.m
function y = ZDT3(varargin)
    % 将输入的逗号分隔的数字转换为向量 x
    x = [varargin{:}];  % 将输入的参数合并为一个向量
    dim = length(x);    % 计算维度
    % ZDT3 评估函数
    y1 = x(1);
    g = 1 + 9 * sum(x(2:dim)) / (dim - 1);
    y2 = g * (1 - sqrt(x(1) / g) - (x(1) / g) * sin(10 * pi * x(1)));
    % 将 y 变为列向量 [y1; y2]
    y = [y1; y2];
end

% ZDT4.m
function y = ZDT4(varargin)
    % 将输入的逗号分隔的数字转换为向量 x
    x = [varargin{:}];  % 将输入的参数合并为一个向量
    dim = length(x);    % 计算维度
    % ZDT4 评估函数
    y1 = x(1);
    g = 1 + 10 * (10 - 1);
    for i = 2:10
        g = g + x(i)^2 - 10 * cos(4 * pi * x(i));
    end
    y2 = g * (1 - sqrt(x(1) / g));
    % 将 y 变为列向量 [y1; y2]
    y = [y1; y2];
end

% ZDT6.m
function y = ZDT6(varargin)
    % 将输入的逗号分隔的数字转换为向量 x
    x = [varargin{:}];  % 将输入的参数合并为一个向量
    dim = length(x);    % 计算维度
    % ZDT6 评估函数
    y1 = 1 - exp(-4 * x(1)) * (sin(6 * pi * x(1)))^6;
    g = 1 + 9 * (sum(x(2:dim)) / (dim - 1))^0.25;
    y2 = g * (1 - (y1 / g)^2);
    % 将 y 变为列向量 [y1; y2]
    y = [y1; y2];
end