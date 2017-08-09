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

	def __repr__(self):
		return f"[{self.begin}, {self.end})"

def parseItem(usageList, line, item, destFlag):
	if item is None: return
	if not item.startswith("xt"): return
	i = item.find(".")
	if i >= 0:
		selector = flags2writeMask(item[i+1:])
		index = int(item[2:i])
	else:
		selector = flags2writeMask(None)
		index = int(item[2:])
	usageList[index][line] |= selector << (4 if destFlag else 0)

def parseCode(usageList, line, code):
	parseItem(usageList, line, code[1], True)
	parseItem(usageList, line, code[2], False)
	parseItem(usageList, line, code[3], False)

def test(output_code):
	print("=====================================")
	for i, code in enumerate(output_code): print(i, code)
	
	usageList = [[0] * len(output_code) for _ in range(8)]
	for line, code in enumerate(output_code): parseCode(usageList, line, code)
	usageList = [[Info(i, v) for i, v in enumerate(usage) if v > 0] for usage in usageList if sum(usage) > 0]

	for usage in usageList:
		for i in reversed(range(len(usage))):
			item = usage[i]
			if isReadWrite(item):
				usage.insert(i+1, item.split())

	assert all(isWriteOnly(v[0]) and isReadOnly(v[-1]) for v in usageList)
	
	index = len(usageList) - 1
	usedList = findUsedRange(usageList[index])
	freeListGroup = [findFreeRange(usageList[i]) for i in range(index)]
	print(usedList)
	return
	if not isUsedListInFreeListGroup(freeListGroup, usedList):
		return
	for i in reversed(range(index)):
		for used in usedList:
			if isUsedInFreeList(freeListGroup[i], used):
				replaceOutputCode(output_code, used, index, i)
	test(output_code)

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

def isUsedInFreeList(freeList, used):
	print("freeList", freeList[0], used)
	return all(any(used in free for free in freeList[i]) for i in range(4))

def isUsedListInFreeListGroup(freeListGroup, usedList):
	return all(all(any(used in free for freeList in freeListGroup for free in freeList[i]) for used in usedList[i]) for i in range(4))

def replaceOutputCode(output_code, used, old, new):
	for code in output_code[used.begin:used.end]:
		for i in range(1, len(code)):
			if code[i] is None: continue
			code[i] = code[i].replace(f"xt{old}", f"xt{new}")

