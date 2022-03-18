function pv = PreProcess(feaFile, Debug)
    %audio to pv
    fea = jsondecode(fileread(feaFile));
    pv.pitch=fea.vocal_pitch;
    pv.time=fea.time;
    if Debug == 1
%         opt=pvPlot('defaultOpt');
%         opt.showPlayButton=0;
%         figure; pvPlot(pv, opt);
%         timeInterval=[0 28]; %changable
%         pv=pvSubsequence(pv, timeInterval);
%         pv.name='Singing pitch of the first phrase';
%         figure; pvPlot(pv);
    end
end