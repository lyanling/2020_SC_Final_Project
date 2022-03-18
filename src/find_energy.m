% x = [8 10 2; 8 10 2];
% y = [0 2  0; 14 13 14];
% plot(x, y);

addingpath();

input_size=input('input size = ?\n');

%debugging
%debug_pre=input('debug for preprocessing?\n'); 


for i = 1 : input_size
    %groundtruth_file
    gtFile = sprintf('./MIR-ST500/%d/%d_groundtruth.txt', i, i); %'./MIR-ST500/1/1_groundtruth.txt';
    note=noteFileRead(gtFile);
    
    %feature_file
    
    feaFile= sprintf('./MIR-ST500/%d/%d_feature.json', i, i); %'./MIR-ST500/1/1_feature.json';
    if feaFile<0, error('Cannot open input file "%s"!', inputFile); end
    
    fea = jsondecode(fileread(feaFile));
    time = fea.time;
    energy = fea.energy;
    zcr = fea.zcr;
    pitch = fea.vocal_pitch;
    % timeInterval = [27 33.5];
    % pv.pitch = fea.pitch;
    % pv.energy = fea.energy;
    % pv.time = fea.time;
    %
    % if debug_pre == 1
    %     pv = pvSubsequence(pv, timeInterval);
    % end
    
    %figure; note=noteSubsequence(note, timeInterval, 1);
    
    A = [note.start'; note.start'];
    B = zeros([2 size(note.pitch, 1)]);
    C = A + [note.duration'; note.duration'];
    B(1, :) = 40;
    B(2, :) = 70;
    note_end = note.start + note.duration;
    %size(A)
    %size(B)
    figure;
    %plot(time,zcr)
    %plot(time, zcr + 40, time, zcr + 40, '.', time, energy * 100+45, time, energy * 100+45, '.', note.start, note.pitch, 'o', note.start, note.pitch, A, B, note_end, note.pitch, 'p', C, B, time, pitch, 'r');
    brighten(colormap, -0.8);
    plot(time, zcr + 47, 'b', time, zcr + 47, 'b.', note.start, note.pitch, 'o', note.start, note.pitch, 'k', A, B, 'r', note_end, note.pitch, 'p', C, B, 'r');
    title(feaFile);
    axis([20, 50, 35, 70]);
end
