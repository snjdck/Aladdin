import re, os, sys
from agal import run
from agalw import CodeWriter, FileWriter

class Module: pass
class ModuleLoader():
	def find_module(self, name, path=None):
		self.path = os.path.join(os.path.dirname(__file__), name + ".py")
		if os.path.exists(self.path):
			return self

	def load_module(self, name):
		with open(self.path) as f:
			data = f.read()
			data = re.sub(r"(?<!\w)(op|oc)(?!\w|\[)", r"\1[0]",  data)
			data = re.sub(r"(?<!\w)(op|oc|v)(\d+)",   r"\1[\2]", data)
		module = Module()
		exec(compile(data, self.path, "exec"), module.__dict__)
		sys.modules[name] = module
		return module

def main(file_path):
	file_name = os.path.basename(file_path)
	file_name = file_name[:file_name.index(".")]
	module = __import__(file_name)

	va = run(module.vertex)
	fs = run(module.fragment)

	test(va.output_code)

	CodeWriter().compile(va, 0, 1)
	CodeWriter().compile(fs, 1, 1)

	save_path = os.path.join(os.path.dirname(file_path), "__agal__")
	if not os.path.exists(save_path): os.mkdir(save_path)
	FileWriter().write(va, fs).save(os.path.join(save_path, file_name))

FLAG_R = 1
FLAG_W = 2

def test(output_code):
	print("=====================================")
	usage = [[0] * len(output_code) for _ in range(8)]
	def fuck(item, line, flag):
		if item is None: return
		if item.startswith("xt"):
			index = int(item[2:item.index(".")] if "." in item else item[2:])
			usage[index][line] |= flag
	for i, code in enumerate(output_code):
		print(code)
		fuck(code[1], i, FLAG_W)
		fuck(code[2], i, FLAG_R)
		fuck(code[3], i, FLAG_R)
	usage = {i:[(j, t) for j, t in enumerate(v) if t > 0] for i, v in enumerate(usage) if sum(v) > 0}
	
	max_key_index = max(usage.keys())
	usedList = calcUsedRange(usage[max_key_index])
	for i in reversed(range(max_key_index)):
		freeList = calcFreeRange(usage[i])
		if isUsedListInFreeList(freeList, usedList):
			replaceOutputCode(output_code, max_key_index, i)
			test(output_code)
			break

	

def calcFreeRange(usage):
	assert usage[0][1] == FLAG_W and usage[-1][1] == FLAG_R
	#可以先写入xyz,再写入w.所以不用检查连续写操作
	free = []
	if usage[0][0] > 0:
		free.append((0, usage[0][0]))
	for i in range(len(usage)-1):
		if usage[i][1] == FLAG_R and usage[i+1][1] == FLAG_W:
			free.append((usage[i][0], usage[i+1][0]))
	free.append((usage[-1][0], 0xFFFF))
	return free

def calcUsedRange(usage):
	used = []
	index = usage[0][0]
	for i in range(1, len(usage)):
		if usage[i][1] == FLAG_W:
			used.append((index, usage[i-1][0]))
			index = usage[i][0]
	used.append((index, usage[-1][0]))
	return used

def isUsedListInFreeList(freeList, usedList):
	return all(isUsedInFreeList(freeList, used) for used in usedList)

def isUsedInFreeList(freeList, used):
	return any(free[0] <= used[0] and used[1] <= free[1] for free in freeList)

def replaceOutputCode(output_code, old, new):
	print("replace", old, new)
	for code in output_code:
		for i in range(1, len(code)):
			if code[i] is None: continue
			code[i] = code[i].replace(f"xt{old}", f"xt{new}")

if __name__ == "__main__":
	#sys.meta_path.insert(0, ModuleLoader())
	input(main(sys.argv[1]))
	#main(sys.argv[1])