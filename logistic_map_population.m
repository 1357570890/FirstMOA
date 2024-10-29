function population = logistic_map_population(r, x0_base, nPop, nVar, burn_in)
    % logistic_map_population ʹ��Logisticӳ��������Ⱥ
    % r: Logisticӳ��Ĳ���
    % x0_base: ������ʼֵ
    % nPop: ��Ⱥ��С
    % nVar: ���߱�������
    % burn_in: �����ڣ�ȥ��ǰburn_in��ֵ

    population = zeros(nPop, nVar);
    for var = 1:nVar
        % Ϊÿ���������΢С�Ŷ���������ȫ��ͬ�ĳ�ʼֵ
        perturb = (rand() - 0.5) * 0.1; 
        xi0 = x0_base + perturb; 
        xi0 = min(max(xi0, 0.01), 0.99); % ��֤��ʼֵ�� (0,1) ��
        x = logistic_map(r, xi0, nPop + burn_in);
        x = x(burn_in+1:end);
        population(:, var) = x;
    end
end