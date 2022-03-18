import json

in_file = 'output.json'
In_fd = open(in_file, 'r')
out_file  = 'AIcup_1_0001_3_1_01_01.json' #aver_err, lpn, tgn, th, tl
Out_fd = open(out_file, 'w')


t = {}

for i in range(1, 1501):
	r = In_fd.readline()
	rr = json.loads(r)
	a = 'song' + str(i)
	t[str(i)] = rr[a]


tt = json.dumps(t)

print(tt, file = Out_fd)

In_fd.close()
Out_fd.close()
