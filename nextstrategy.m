function new_pop = nextstrategy(pop, generation)
    % ��ȡ��Ⱥ��С
    pop_size = size(pop, 1);
    num_variables = size(pop, 2);
    
    % ���ݵ�ǰ������������Ⱥ��С
    % ����Ⱥ��С = ��ǰ��Ⱥ��С * (1 - 0.1 * ��ǰ����)
    new_pop_size = max(1, round(pop_size * (1 - 0.1 * generation))); % ȷ��������һ������
    new_pop = zeros(new_pop_size, num_variables); % ��ʼ������Ⱥ

    % ��������Ⱥ
    for i = 1:new_pop_size
        % ѡ�񸸴�����
        parent1 = select_parent(pop);
        parent2 = select_parent(pop);
        
        % ���н������
        child = crossover(parent1, parent2);
        
        % ���б������
        child = mutate(child);
        
        % ���¸�����ӵ�����Ⱥ��
        new_pop(i, :) = child;
    end
end

function parent = select_parent(pop)
    % ���ѡ��һ����������
    idx = randi(size(pop, 1));
    parent = pop(idx, :);
end

function child = crossover(parent1, parent2)
    % �������Խ������
    alpha = rand();
    child = alpha * parent1 + (1 - alpha) * parent2;
end

function mutated = mutate(individual)
    % �Ը�����б������
    mutation_rate = 0.1; % �������
    if rand() < mutation_rate
        mutation_amount = randn(size(individual)) * 0.1; % �������������
        mutated = individual + mutation_amount; % Ӧ�ñ���
    else
        mutated = individual; % ���û�б��죬����ԭ����
    end
end
