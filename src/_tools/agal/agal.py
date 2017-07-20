def createMethod(name):
	def func(self, other=None):
		if self in regStack:
			reg = self
			if other in regStack:
				regStack.put(other)
		elif other in regStack:
			reg = other
		else:
			reg = regStack.get()
		if other is None:
			addCode(name, reg, self)
		else:
			addCode(name, reg, self, other)
		return reg
	return func

class Operatorable:
	__add__		= createMethod("add")
	__sub__		= createMethod("sub")
	__mul__ 	= createMethod("mul")
	__truediv__	= createMethod("div")
	__pow__		= createMethod("pow")
	__neg__		= createMethod("neg")


dp4 = createMethod("dp4")


class RegisterStack:
	def __init__(self, idSet):
		self.stack = list(idSet)
		self.using = set()

	def reset(self):
		while len(self.using):
			self.stack.append(self.using.pop())

	def get(self):
		index = self.stack.pop()
		self.using.add(index)
		return RegisterSlot(VT, index)
	
	def put(self, item):
		assert item in self
		index = item.index
		self.using.remove(index)
		self.stack.append(index)
	
	def __contains__(self, item):
		if type(item) is RegisterSlot:
			return item.name is VT and item.index in self.using
		if type(item) is VT:
			return item.index in self.using and item.selector == "xyzw"
		return False


class Register(Operatorable):
	def __init__(self, index, selector=None):
		self.index = index
		self.selector = selector or "xyzw"

	def value(self):
		return self

	def __str__(self):
		name = type(self).__name__.lower()
		if self.selector == "xyzw":
			return f"{name}{self.index}"
		return f"{name}{self.index}.{self.selector}"


class RegisterSlot(Operatorable):
	def __init__(self, name, index):
		object.__setattr__(self, "name", name)
		object.__setattr__(self, "index", index)

	def __getattr__(self, name):
		return self.name(self.index, name)

	def __setattr__(self, name, value):
		register = getattr(self, name)
		if value in regStack:
			updateLastCode(register)
		else:
			addCode("mov", register, value)
		regStack.reset()

	def value(self):
		return getattr(self, "xyzw")


class RegisterGroup:
	def __init__(self, name, count):
		self.group = [RegisterSlot(name, i) for i in range(count)]
		self.count = count

	def __len__(self):
		return self.count

	def __getitem__(self, key):
		return self.group[key]

	def __setitem__(self, key, value):
		slot = self.group[key]
		if value in regStack:
			updateLastCode(slot)
		else:
			slot.xyzw = value
		regStack.reset()

#=============================================================================
def addCode(op, dest, source1, source2=None):
	codeList.append([op, dest.value(), source1.value(), source2 and source2.value()])

def updateLastCode(dest):
	codeList[-1][1] = dest.value()

codeList = []
#=============================================================================

class VT(Register): pass
class FT(Register): pass
class VC(Register): pass
class FC(Register): pass
class VA(Register): pass
class FS(Register): pass
class OP(Register): pass
class OC(Register): pass

vt = RegisterGroup(VT, 8)
ft = RegisterGroup(FT, 8)
vc = RegisterGroup(VC, 128)
fc = RegisterGroup(FC, 64)
va = RegisterGroup(VA, 8)
fs = RegisterGroup(FS, 8)
op = RegisterGroup(OP, 1)
oc = RegisterGroup(OC, 1)

regStack = None

import re

def begin(file):
	with open(file) as f:
		data = f.read()
	idSet = re.findall(r"vt\[(\d+)\]", data)
	idSet = set(map(int, idSet))
	global regStack
	regStack = RegisterStack(set(range(len(vt))) - idSet)

def end():
	print("\n".join(" ".join(str(key) for key in item if key is not None) for item in codeList))
	input()