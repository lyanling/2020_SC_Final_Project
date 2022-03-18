addingpath();

fprintf('Platform: %s\n', computer);
fprintf('MATLAB version: %s\n', version);
fprintf('Date & time: %s\n', char(datetime));
scriptStartTime=tic;	% Timing for the whole script
input_size=input('input size = ?');

%debugging
debug_pre=input('debug for preprocessing?\n'); 
debug_MIR = input('debug for MIR?\n');
debug_print = input('debug for print?\n');

%input, output file 
inputFile='feature_input.txt';   
outputFile='output.json';
fidInput=fopen(inputFile, 'r');
if fidInput<0, error('Cannot open input file "%s"!', inputFile); end
fidOutput=fopen(outputFile, 'w');
if fidOutput<0, error('Cannot open output file "%s"!', outputFile); end


for i=1:input_size
    if debug_MIR == 0
        feaFile = fgetl(fidInput);
    else
        feaFile = sprintf('./MIR-ST500/%d/%d_feature.json', i, i);
    end
    pv = PreProcess(feaFile, debug_pre);
   
    after_zcr = my_zcr(feaFile);
    z_size = size(after_zcr, 1);
    for j=1:z_size
        start = after_zcr(j, 1);
        eend = after_zcr(j, 2);
        if start == eend %??????
            continue;
        end
        sub_pitch = pv.pitch(start:eend, 1);
        sub_time = pv.time(start:eend, 1);
        %??output
        if j == 1
            new_result = dp(sub_pitch, sub_time, start);
            if new_result ~= [0 0 0]
                result = new_result;
            else
                result = [0 0 0];
            end
        else
            new_result = dp(sub_pitch, sub_time, start);
            if new_result ~= [0 0 0]
                if result ~= [0 0 0]
                    result = cat(1, result, new_result);
                else
                    result = new_result;
                end
            end
        end
    end
    
    % Write to output file
    js=struct("song"+i, result);
    jsonencode(js);
    jsx = jsonencode(js);
    fprintf(fidOutput, '%s\n', jsx);
end

fclose(fidInput);
fclose(fidOutput);

% ansss_debug
if debug_print == 1
    outputFile='ansss_debug';
    fidOutput=fopen(outputFile, 'w');
    if fidOutput<0, error('Cannot open output file "%s"!', outputFile); end
    for i = 1 : size(result, 1)
        fprintf(fidOutput, '%f %f %d\n', result(i, 1), result(i, 2), result(i, 3));
    end
end

% time, pitch
if debug_print == 1
    outputFile='pitch_time_debug';
    fidOutput=fopen(outputFile, 'w');
    if fidOutput<0, error('Cannot open output file "%s"!', outputFile); end
    for i = 1 : size(pv.time, 1)
        fprintf(fidOutput, '%.6f %.6f\n', pv.time(i), pv.pitch(i));
    end
end