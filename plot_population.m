function plot_population(Objs)
    plot(Objs(1,:), Objs(2,:), 'r*', 'MarkerSize', 8); % ����Ŀ�꺯��ֵ
    xlabel('f1'); % x���ǩ
    ylabel('f2'); % y���ǩ
    title('GA and Greywolf Optimization'); % ͼ�����
    grid on; % ��ʾ����
    pause(0.01); % ��ͣ�Ա�۲�
end