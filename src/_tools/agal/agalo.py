from functools import reduce
from operator import add
from agalw import flags2writeMask, char2val

__all__ = ["test"]

isRead  = lambda item: bool(item.value & 0x0F)
isWrite = lambda item: bool(item.value & 0xF0)
isReadOnly  = lambda item: isRead(item) and not isWrite(item)
isWriteOnly = lambda item: not isRead(item) and isWrite(item)
isReadWrite = lambda item: isRead(item) and isWrite(item)

class Info:
	__slots__ = ("index", "value")
	def __init__(self, index, value):
		self.index = index
		self.value = value

	def split(self):
		info = Info(self.index, self.value & 0xF0)
		self.value &= 0x0F
		return info

	def active(self, index):
		return self.value & 0x11 << index

	def readable(self, index):
		return self.value & 0x01 << index

	def writable(self, index):
		return self.value & 0x10 << index

	def __repr__(self):
		return f"{self.index}@{self.value}"

class Range:
	__slots__ = ("begin", "end")
	def __init__(self, begin=0, end=0xFFFF):
		self.begin = begin
		self.end = end

	def __contains__(self, other):
		return self.begin <= other.begin and other.end <= self.end

	def __and__(self, other):
		nbegin = max(self.begin, other.begin)
		nend = min(self.end, other.end)
		return Range(nbegin, nend) if nbegin < nend else None

	def __or__(self, other):
		nbegin = min(self.begin, other.begin)
		nend = max(self.end, other.end)
		return Range(nbegin, nend)

	def __repr__(self):
		return f"[{self.begin}, {self.end})"

def fuck(usedList):
	for i in range(len(usedList)):
		for j in range(i+1, len(usedList)):
			if usedList[i] & usedList[j]:
				usedList[i] |= usedList[j]
				del usedList[j]
				return fuck(usedList)
	return usedList

def parseItem(usageList, line, item, destFlag):
	if item is None or not item.startswith("xt"): return
	i = item.find(".")
	selector = flags2writeMask(item[i+1:] if i >= 0 else None)
	item = item[2:i] if i >= 0 else item[2:]
	usageList[int(item)][line] |= selector << (4 if destFlag else 0)

def test(output_code):
	usageList = [[0] * len(output_code) for _ in range(8)]
	for line, code in enumerate(output_code):
		for i in range(1, 4):
			parseItem(usageList, line, code[i], i == 1)
	usageList = [[Info(i, v) for i, v in enumerate(usage) if v > 0] for usage in usageList if sum(usage) > 0]

	for usage in usageList:
		for i in reversed(range(len(usage))):
			item = usage[i]
			if isReadWrite(item):
				usage.insert(i+1, item.split())

	assert all(isWriteOnly(v[0]) and isReadOnly(v[-1]) for v in usageList)
	
	index = len(usageList) - 1
	usedList = findUsedRange(usageList[index])
	testRangeList = fuck(reduce(add, usedList))
	
	needNextCall = False
	for testRange in testRangeList:
		for i in reversed(range(index)):
			if isUsedInFreeList(findFreeRange(usageList[i]), usedList, testRange):
				replaceOutputCode(output_code, testRange, index, i)
				needNextCall = True
				break
	if needNextCall: test(output_code)

def findFreeRange(usage):
	result = []
	for usedList in findUsedRange(usage):
		if len(usedList) <= 0:
			result.append(Range())
			continue
		freeList = []
		if usedList[0].begin > 0:
			freeList.append(Range(0, usedList[0].begin))
		for j in range(len(usedList)-1):
			freeList.append(Range(usedList[j].end, usedList[j+1].begin))
		freeList.append(Range(usedList[-1].end))
		result.append(freeList)
	return result

def findUsedRange(usage):
	result = []
	for i in range(4):
		usedList = [item for item in usage if item.active(i)]
		for j in reversed(range(1, len(usedList))):
			if usedList[j].readable(i) == usedList[j-1].readable(i):
				del usedList[j-1]
		for j in reversed(range(len(usedList)-1)):
			if usedList[j].index == usedList[j+1].index:
				del usedList[j:j+2]
		assert len(usedList) % 2 == 0
		result.append([Range(usedList[j].index, usedList[j+1].index) for j in range(0, len(usedList), 2)])
	return result

def isUsedInFreeList(freeList, usedList, testRange):
	for i in range(4):
		for used in usedList[i]:
			if used not in testRange:
				continue
			if not any(used in free for free in freeList[i]):
				return False
	return True

def replaceOutputCode(output_code, used, old, new):
	print("replace", used, old, new)
	for line in range(used.begin, used.end+1):
		code = output_code[line]
		oldCode = code.copy()
		for i in range(1, len(code)):
			if code[i] is None: continue
			code[i] = code[i].replace(f"xt{old}", f"xt{new}")
		if code == oldCode: continue
		print(f"{line}\t", oldCode)
		print("\t", code)
		print("----")

