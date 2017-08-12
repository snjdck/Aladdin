from functools import reduce
from operator import add, setitem, delitem
from itertools import chain, combinations
from agalw import flags2writeMask, char2val

__all__ = ["optimize"]

eachpair	= lambda item: [(i, item[i], item[i+1]) for i in reversed(range(len(item)-1))]
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
		if type(other) is int: return self.begin <= other <= self.end
		return self.begin <= other.begin and other.end <= self.end

	def __and__(self, other):
		v = Range(max(self.begin, other.begin), min(self.end, other.end))
		return v if v.begin <= v.end else None

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
		if a & b: return unionUsedRange(usedList ^ {a, b, a | b})
	return usedList

def parseItem(usageList, line, item, index):
	if item is None or not item.startswith("xt"): return
	i = item.find(".")
	selector = flags2writeMask(item[i+1:] if i >= 0 else None)
	item = item[2:i] if i >= 0 else item[2:]
	usageList[int(item)][line] |= selector << (4 if index == 1 else 0)

def calcUsageList(func):
	def wrapper(output_code):
		usageList = [[0] * len(output_code) for _ in range(8)]
		[parseItem(usageList, line, code[i], i) for line, code in enumerate(output_code) for i in range(1, 4)]
		usageList = [[Info(i, v) for i, v in enumerate(usage) if v > 0] for usage in usageList if sum(usage) > 0]
		if len(usageList) < 2: return
		usageList = [list(chain.from_iterable(item.split() for item in usage)) for usage in usageList]
		assert all(isWriteOnly(v[0]) and isReadOnly(v[-1]) for v in usageList)
		return func(output_code, usageList)
	return wrapper

@calcUsageList
def optimizeMOV(output_code, usageList):
	for i, usage in enumerate(usageList):
		for item in unionUsedRange(set(reduce(add, findUsedRange(usage)))):
			if [isWrite(v) for v in usage if v.index in item].count(True) > 1: continue
			if output_code[item.end][0] != "mov": continue
			dest, source = output_code[item.end][1:3]
			destFlags = dest[dest.index(".")+1:] if "." in dest else "xyzw"
			sourceFlags = source[source.index(".")+1:] if "." in source else "xyzw"
			if not all(sourceFlags[char2val(v)] == v for v in destFlags): continue
			replaceOutputCode(output_code, item, f"xt{i}", dest[:dest.index(".")] if "." in dest else dest)
			del output_code[item.end]
			return optimizeMOV(output_code)

@calcUsageList
def optimizeXT(output_code, usageList):
	index = len(usageList) - 1
	usedList = findUsedRange(usageList[index])
	for testRange in unionUsedRange(set(reduce(add, usedList))):
		for i in reversed(range(index)):
			if isUsedInFreeList(findFreeRange(usageList[i]), usedList, testRange):
				replaceOutputCode(output_code, testRange, f"xt{index}", f"xt{i}")
				return optimizeXT(output_code)

def optimize(output_code):
	optimizeXT(output_code)
	optimizeMOV(output_code)

@exec4times
def findFreeRange(usage, offset):
	usedList = _findUsedRange(usage, offset)
	if len(usedList) <= 0: return [Range()]
	freeList  = [item for item in [Range(0, usedList[0].begin)] if item.end > 0]
	freeList += [Range(usedList[j].end, usedList[j+1].begin) for j in range(len(usedList)-1)]
	return freeList + [Range(usedList[-1].end)]

def _findUsedRange(usage, offset):
	usedList = [item for item in usage if item.active(offset)]
	[delitem(usedList, i) for i, a, b in eachpair(usedList) if a.readable(offset) == b.readable(offset)]
	[delitem(usedList, slice(i, i+2)) for i, a, b in eachpair(usedList) if a.index == b.index]
	assert len(usedList) % 2 == 0
	return list(reversed([Range(a.index, b.index) for i, a, b in eachpair(usedList) if i % 2 == 0]))
findUsedRange = exec4times(_findUsedRange)

def isUsedInFreeList(freeList, usedList, testRange):
	return all(any(used in free for free in freeList[i]) for i in range(4) for used in usedList[i] if used in testRange)

def replaceOutputCode(output_code, used, old, new):
	print("replace", used, old, new)
	old_code = [str(code) for code in output_code]
	[setitem(output_code[i], k, v.replace(old, new)) for i in range(used.begin, used.end+1) for k, v in enumerate(output_code[i]) if v]
	[print(f"{line}\t", old_code[line], "->", code) for line, code in enumerate(output_code) if str(code) != old_code[line]]
