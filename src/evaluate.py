import mir_eval

total_score = 0.0

for i in range(1, 501):
    ref_intervals, ref_pitches = mir_eval.io.load_valued_intervals('sample500/' + str(i) + '_gt.txt')
    est_intervals, est_pitches = mir_eval.io.load_valued_intervals('sample500/' + str(i) + '.txt')
    scores = mir_eval.transcription.evaluate(ref_intervals, ref_pitches, est_intervals, est_pitches)

    COn = scores['Onset_F-measure']
    COnP = scores['F-measure_no_offset']
    COnPOff = scores['F-measure']

    total_score += COn * 0.2 + COnP * 0.6 + COnPOff * 0.2
    #print('finish ' + str(i))

print(total_score/500)