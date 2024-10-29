function [nPc, nPr, nPm] = adjustPopulationCounts(nPop, Pc, Pr, Pm)
    % 计算交叉、重复和变异操作的个体数量
    nPc = floor(nPop * Pc);  % 向下取整
    nPr = floor(nPop * Pr);  % 向下取整
    nPm = floor(nPop * Pm);  % 向下取整

    % 确保 nPc 为偶数
    if mod(nPc, 2) ~= 0
        nPc = nPc - 1;  % 如果 nPc 是奇数，则减去 1
    end
end
