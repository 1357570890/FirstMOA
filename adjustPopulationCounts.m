function [nPc, nPr, nPm] = adjustPopulationCounts(nPop, Pc, Pr, Pm)
    % ���㽻�桢�ظ��ͱ�������ĸ�������
    nPc = floor(nPop * Pc);  % ����ȡ��
    nPr = floor(nPop * Pr);  % ����ȡ��
    nPm = floor(nPop * Pm);  % ����ȡ��

    % ȷ�� nPc Ϊż��
    if mod(nPc, 2) ~= 0
        nPc = nPc - 1;  % ��� nPc �����������ȥ 1
    end
end
