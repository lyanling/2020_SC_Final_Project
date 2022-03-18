import json

person = {'song1': 'jim', 'song2': 25, 'song3': 'Taiwan', 'song4' : (1, 2, 3)}

data = json.dumps(person)

print(type(data)) #<class 'str'>
print(data) #{"name": "jim", "age": 25, "city": "Taiwan"}

s = {}
for i in range(1, 5):
	a = 'song' + str(i)
	s[str(i)] = person[a]

ss = json.dumps(s)
print(ss)


file = './ttj.json'
fd = open(file, 'w')
print(data, file = fd)
fd.close()