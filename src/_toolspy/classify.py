from functools import reduce

pt_list = [(2,1,1),(3,1,1),(1,2,0),(1,5,0)]
'''
ax + b = 0


ax + by + c = 0
a * dx + b * dy = 0

ax + by + cz + d = 0
a * dx + b * dy + c * dz = 0

ax + by + cz + dw + e = 0
'''


def fuck(item_list, size=0):
	item0 = item_list[0]
	if size <= 0: size = len(item0)
	if size == 1: return [1, -item0[0]]

	delta_list = [[item0[j] - item_list[i][j] for j in range(size)] for i in range(1, size)]
	total = reduce(lambda x, y: x * y[-1], delta_list, 1)
	delta_list = [[(total / delta[-1] if delta[-1] != 0 else 1) * item for item in delta] for delta in delta_list]
	result = fuck(delta_list, size - 1)
	for i in range(size - 1): result[i] *= total
	result.append(-reduce(lambda x, y: x + y, [item0[i] * result[i] for i in range(size)]))
	
	return result


def calcArea(item_list):
	size = len(item_list[0])
	_min = [0] * size
	_max = [0] * size
	for i in range(size):
		group = [item[i] for item in item_list]
		_min[i] = min(group)
		_max[i] = max(group)
	return _min, _max

def calcCenter(item_list):
	size = len(item_list[0])
	center = [0] * size
	for i in range(size):
		center[i] = reduce(lambda a, b: a[i] + b[i], item_list) / len(item_list)
	return center


test_list = [(5,2,1),(4,3,1)]

a_list = [list(item)[:-1] for item in pt_list if item[2] == 1]
b_list = [list(item)[:-1] for item in pt_list if item[2] == 0]

center_list = [calcCenter([calcCenter(a_list), calcCenter(b_list)])]
for i in range(len(a_list[0])-1):
	center_list.append(calcCenter([a_list[i], b_list[i]]))

print(a_list, calcCenter(a_list))
print(b_list, calcCenter(b_list))
print(center_list, fuck(center_list))

#15 -9 -13 -29
print(fuck([(0,4,-5),(-1,-2,-2),(4,2,1)]))

print(fuck([(4,4),(-1,4)]))
print(fuck([(5,5),(5,4)]))

#input()