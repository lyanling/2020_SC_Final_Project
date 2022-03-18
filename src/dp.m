function output = dp(pitch, time, start)

pitch_size = size(pitch, 1);
num_sub = 0;
i = 1;
sub(1, 1) = 0;
while i < pitch_size
    if pitch(i) == 0
        i = i + 1;
        continue;
    end
    num_sub = num_sub + 1;
    sub(num_sub, 1) = i; %start
    for k = i + 1 : pitch_size
        if pitch(k) == 0
            break;
        end
    end
    sub(num_sub, 2) = k-1; %end
    i = k;
end
%size(pitch)
%size(time)
%size(sub)

if num_sub == 0
    output = [0 0 0];
    return;
end

num_pitch = 0;
for n = 1 : size(sub, 1)
    s = sub(n, 1); % start of a music phrase
    t = sub(n, 2); % end of a music phrase
    out = find_path(pitch(s:t, 1), time(s:t, 1));
    for i = 1 : size(out, 1)
        num_pitch = num_pitch + 1;
        output_tmp(num_pitch, 1:3) = out(i, 1:3);
    end
end

num_pitch = 0;
for i = 1 : size(output_tmp, 1)
    if output_tmp(i, 1) ~= output_tmp(i, 2)
        num_pitch = num_pitch + 1;
        output(num_pitch, 1:3) = output_tmp(i, 1:3);
    end
end

if num_pitch == 0
    output = [0 0 0];
end

end