function plot_population(Objs)
    plot(Objs(1,:), Objs(2,:), 'r*', 'MarkerSize', 8); % 绘制目标函数值
    xlabel('f1'); % x轴标签
    ylabel('f2'); % y轴标签
    title('GA and Greywolf Optimization'); % 图表标题
    grid on; % 显示网格
    pause(0.01); % 暂停以便观察
end