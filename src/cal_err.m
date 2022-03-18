function err = cal_err(array)

med = median(array);
err = 0;
for i = 1 : size(array, 1)
    err = err + abs(array(i, 1) - med);
end
end