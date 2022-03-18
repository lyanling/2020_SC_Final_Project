function path = find_path(pitch, time)
pitch_size = size(pitch, 1);

%threshold
aver_err = 0.001; % for dp
least_pitch_num = 3; % for a music phrase
time_gap_num = 1; % for two contiguous phrases

dp_table(1, 1) = 0;
dp_table(2, 1) = Inf;

%dp
for i = 2 : pitch_size
    dp_table(i+1, i) = Inf;
    for j = 1 : i
        if j == 1
            dp_table(j, i) = cal_err(pitch(1:i));
        else
            k = i - 1;
            while k >= j
                if dp_table(j, k) == dp_table(j-1, k-1)
                    break;
                end
                k = k-1;
            end
            a = cal_err(pitch(k:i)) + dp_table(j, k);
            b = dp_table(j-1, i-1);        
            dp_table(j, i) = min(a, b);
        end
    end
end

% path reconstruction (?error ??????????)
num = 1;
row = 1;
for i = 2 : size(dp_table, 1)
    if dp_table(i, pitch_size) > 0 && dp_table(i, pitch_size) < dp_table(row, pitch_size)
        row = i;
    end
end

i = pitch_size;
tail = pitch_size;

while i >= 1
    if row == 1 || i == 1
        r_path(num, 1) = time(1);
        r_path(num, 2) = time(tail);
        r_path(num, 3) = median(pitch(1:tail));
        r_path_se(num, 1) = 1; % the index of the start note
        r_path_se(num, 2) = tail; % the index of the end note
        break;
    end
    if dp_table(row-1, i-1) == dp_table(row, i)
        if cal_err(pitch(i-1:tail)) <= aver_err * (tail - (i-1) + 1)
            row = row - 1;
        else
            row = row - 1;
            r_path(num, 1) = time(i);
            r_path(num, 2) = time(tail);
            r_path(num, 3) = median(pitch(i : tail));
            r_path_se(num, 1) = i;
            r_path_se(num, 2) = tail;
            num = num + 1;
            tail = i-1;
        end
    end
    i = i - 1;
end

% reverse
i = size(r_path, 1);
j = 1;
while i >= 1
    path_0(j, 1:3) = r_path(i, 1:3);
    path_0_se(j, 1:2) = r_path_se(i, 1:2);
    j = j + 1;
    i = i - 1;
end

% ??
if size(path_0, 1) > 1
    % merge
    for i = 1 : size(path_0, 1)
        if path_0(i, 3) ~= 0 && abs(path_0_se(i, 2) - path_0_se(i, 1)) < least_pitch_num
            front = i - 1;
            while front >= 1
                if path_0(front, 3) ~= 0
                    break;
                end
                front = front - 1;
            end
            back = i + 1;
            while back <= size(path_0, 1)
                if path_0(back, 3) ~= 0
                    break;
                end
                back = back + 1;
            end
            if (front < i && front >= 1)
                if back == i || back > size(path_0, 1)
                    path_0(front, 2) = path_0(i, 2);
                    path_0(i, 3) = 0;
                    path_0(front, 3) = median(pitch(path_0_se(front, 1):path_0_se(i, 2)));
                    path_0_se(front, 2) = path_0_se(i, 2);
                    continue;
                elseif abs(path_0(front, 3) - path_0(i, 3)) < abs(path_0(back, 3) - path_0(i, 3))
                    path_0(front, 2) = path_0(i, 2);
                    path_0(i, 3) = 0;
                    path_0(front, 3) = median(pitch(path_0_se(front, 1):path_0_se(i, 2)));
                    path_0_se(front, 2) = path_0_se(i, 2);
                    continue;
                end
            end
            
            if back > i && back <= size(path_0, 1)
                path_0(back, 1) = path_0(i, 1);
                path_0(i, 3) = 0;
                path_0(back, 3) = median(pitch(path_0_se(i, 1):path_0_se(back, 2)));
                path_0_se(back, 1) = path_0_se(i, 1);
                continue;
            end
        end
    end
    %??????????????pitch??????
    for i = 1 : size(path_0, 1)
        if path_0(i, 3) == 0
            continue;
        end
        front = i - 1;
        while front >= 1
            if path_0(front, 3) ~= 0
                break;
            end
            front = front - 1;
        end
        back = i + 1;
        while back <= size(path_0, 1)
            if path_0(back, 3) ~= 0
                break;
            end
            back = back + 1;
        end
        if back > i && back <= size(path_0, 1) && round(path_0(back, 3)) == round(path_0(i, 3))
            if path_0(back, 1) - path_0(i, 2) <= 0.032 * time_gap_num
                path_0(back, 1) = path_0(i, 1);
                path_0(i, 3) = 0;
                path_0(back, 3) = median(pitch(path_0_se(i, 1):path_0_se(back, 2)));
                path_0_se(back, 1) = path_0_se(i, 1);
                continue;
            end
        end
        if front < i && front >= 1 && round(path_0(front, 3)) == round(path_0(i, 3))
            if path_0(i, 1) - path_0(front, 2) <= 0.032 * 2
                path_0(front, 2) = path_0(i, 2);
                path_0(i, 3) = 0;
                path_0(front, 3) = median(pitch(path_0_se(front, 1):path_0_se(i, 2)));
                path_0_se(front, 2) = path_0_se(i, 2);
            end
        end
        
    end
end

% discard the note with only one frame
% for i = 1 : size(path_0, 1)
%     if path_0(i, 3) ~= 0
%         if path_0(i, 1) == path_0(i, 2)
%             path_0(i, 3) = 0;
%         end
%     end
% end

% size(path_0, 1)

j = 1;
for i = 1 : size(path_0, 1)
    if path_0(i, 3) ~= 0
        path(j, 1:2) = path_0(i, 1:2);
        path(j, 3) = round(path_0(i, 3));
        j = j + 1;
    end
end

% time
% pitch
%dp_table
% r_path
% path_0
% path

end