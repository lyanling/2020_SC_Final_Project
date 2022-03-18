# data 的檔案路徑
path = './AIcup_testset_ok'
# inputFile 的檔案路徑
fea_input_path = './feature_input.txt'
gt_input_path = './gt_input.txt'
fea_f = open(fea_input_path, 'w')
gt_f = open(gt_input_path, 'w')

for i in range(1, 1501):
    # windows 要把 '/' 改成 '\'
    feapath = path + '/' + str(i) + '/' + str(i) + '_feature.json'
    gtpath = path + '/' + str(i) + '/' + str(i) + '_groundtruth.txt'
    print(feapath, file = fea_f)
    print(gtpath, file = gt_f)

fea_f.close()
gt_f.close()