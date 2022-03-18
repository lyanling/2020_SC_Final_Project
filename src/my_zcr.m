function out = my_zcr(feaFile)
%feaFile = './TestData/MIR-ST500/1/1_feature.json';%delete
fea = jsondecode(fileread(feaFile));
z = fea.zcr;
ttime = fea.time;
threshold_h = 0.1; %high, changable
threshold_l = 0.1; %low, changable
z_size = size(z, 1);
num_sub = 1;
i = 2;
sub(1, 1) = 1;
while i < z_size
    if z(i-1) > threshold_h && z(i) <= threshold_l && (z(i-1) - z(i) >= 0.1)
        sub(num_sub, 2) = i - 1;
        sub(num_sub + 1, 1) = i;
        num_sub = num_sub + 1;
    end  
    i = i+1;
end
% while i < z_size
%     if z(i-1) - z(i) > threshold_h
%         k = i + 1;
%         while k < z_size
%             if z(k) < threshold_l
%                 break;
%             else
%                 k = k + 1;
%             end
%         end
%         sub(num_sub, 2) = k - 1;
%         i = k;
%         sub(num_sub + 1, 1) = i;
%         num_sub = num_sub + 1;
%     else
%         i = i+1;
%     end
% end
sub(num_sub, 2) = i;
out = sub;
aa = 0;
% zcr_debug
if aa == 1
    outputFile='zcr_debug';
    fidOutput=fopen(outputFile, 'w');
    if fidOutput<0, error('Cannot open output file "%s"!', outputFile); end
    for i = 1 : size(sub, 1)
        fprintf(fidOutput, '%.6f %.6f\n', ttime(sub(i, 1)), ttime(sub(i, 2)));
    end
end

% time, zcr
if aa == 1
    outputFile='zcr_time_debug';
    fidOutput=fopen(outputFile, 'w');
    if fidOutput<0, error('Cannot open output file "%s"!', outputFile); end
    for i = 1 : size(ttime, 1)
        fprintf(fidOutput, '%.6f %.6f\n', ttime(i), z(i));
    end
end

end