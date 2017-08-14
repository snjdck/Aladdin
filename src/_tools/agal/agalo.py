from functools import reduce
from operator import add, setitem
from itertools import chain, combinations
from agalw import flags2writeMask

eachpair	= lambda item: [(i, item[i], item[i+1]) for i in range(len(item)-1)]
exec4times  = lambda func: lambda usage: [func(usage, i) for i in range(4)]
isRead		= lambda item: item.value & 0x0F > 0
isWrite		= lambda item: item.value & 0xF0 > 0
isReadOnly  = lambda item: 0 < item.value <= 0x0F
isWriteOnly = lambda item: isWrite(item) and not isRead(item)
isReadWrite = lambda item: isWrite(item) and isRead(item)

class Info:
	__slots__ = ("index", "value")
	def __init__(self, index, value):
		self.index = index
		self.value = value

	__repr__ = lambda self: f"{self.index}@{self.value}"
	readable = lambda self, index: self.value & 0x01 << index
	active	 = lambda self, index: self.value & 0x11 << index
	split = lambda self: [Info(self.index, self.value & i) for i in [0x0F, 0xF0]] if isReadWrite(self) else [self]

class Range:
	__slots__ = ("begin", "end")
	def __init__(self, begin=0, end=0xFFFF):
		self.begin = begin
		self.end = end

	def __contains__(self, other):
		return self.begin <= other.begin and other.end <= self.end

	def __and__(self, other):
		v = Range(max(self.begin, other.begin), min(self.end, other.end))
		return v if v.begin < v.end else None

	def __or__(self, other):
		return Range(min(self.begin, other.begin), max(self.end, other.end))

	def __hash__(self):
		return self.begin | self.end << 16

	def __eq__(self, other):
		return self.begin == other.begin and self.end == other.end

	def __repr__(self):
		return f"[{self.begin}, {self.end}]"

def unionUsedRange(usedList):
	for a, b in combinations(usedList, 2):
		if a & b: return unionUsedRange(usedList - {a, b} | {a | b})
	return usedList

def parseItem(usageList, line, item, index):
	if item is None or not item.startswith("xt"): return
	i = item.find(".")
	selector = flags2writeMask(item[i+1:] if i >= 0 else None)
	item = item[2:i] if i >= 0 else item[2:]
	usageList[int(item)][line] |= selector << (4 if index == 1 else 0)

def calcUsageList(handler):
	def wrapper(output_code):
		usageList = [[0] * len(output_code) for _ in range(8)]
		[parseItem(usageList, line, code[i], i) for line, code in enumerate(output_code) for i in range(1, len(code))]
		usageList = [[Info(i, v) for i, v in enumerate(usage) if v > 0] for usage in usageList if sum(usage) > 0]
		if len(usageList) < 2: return
		usageList = [list(chain.from_iterable(item.split() for item in usage)) for usage in usageList]
		assert all(isWriteOnly(v[0]) and isReadOnly(v[-1]) for v in usageList)
		handler(output_code, usageList)
	return wrapper

@calcUsageList
def optimize(output_code, usageList):
	index = len(usageList) - 1
	usedList = findUsedRange(usageList[index])
	for testRange in unionUsedRange(set(reduce(add, usedList))):
		for i in range(index):
			if isUsedInFreeList(findFreeRange(usageList[i]), usedList, testRange):
				replaceOutputCode(output_code, testRange, f"xt{index}", f"xt{i}")
				return optimize(output_code)
@exec4times
def findFreeRange(usage, offset):
	usedList = _findUsedRange(usage, offset)
	if len(usedList) <= 0: return [Range()]
	freeList = [Range(0, usedList[0].begin)] + [Range(a.end, b.begin) for _, a, b in eachpair(usedList)]
	return [x for x in freeList if x.begin < x.end] + [Range(usedList[-1].end)]

def _findUsedRange(usage, offset):
	usedList = [x for x in usage if x.active(offset)]
	[usedList.remove(a) for _, a, b in eachpair(usedList) if a.readable(offset) == b.readable(offset)]
	assert len(usedList) % 2 == 0
	return [Range(a.index, b.index) for i, a, b in eachpair(usedList) if i % 2 == 0]
findUsedRange = exec4times(_findUsedRange)

def isUsedInFreeList(freeList, usedList, testRange):
	return all(any(used in free for free in freeList[i]) for i in range(4) for used in usedList[i] if used in testRange)

def replaceOutputCode(output_code, used, old, new):
	print("replace", used, old, new)
	old_code = [str(code) for code in output_code]
	[setitem(output_code[used.begin], k, v.replace(old, new)) for k, v in enumerate(output_code[used.begin]) if v and k == 1]
	[setitem(output_code[used.end],   k, v.replace(old, new)) for k, v in enumerate(output_code[used.end])   if v and k in (2, 3)]
	[setitem(output_code[i], k, v.replace(old, new)) for i in range(used.begin+1, used.end) for k, v in enumerate(output_code[i]) if v]
	[print(f"{line}\t", old_code[line], "->", code) for line, code in enumerate(output_code) if str(code) != old_code[line]]
