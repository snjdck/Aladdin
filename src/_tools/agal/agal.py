
class Operatorable:
	def __add__(self, other):
		return RegisterOperation("add", self, other)

	def __sub__(self, other):
		return RegisterOperation("sub", self, other)

	def __mul__(self, other):
		return RegisterOperation("mul", self, other)

	def __truediv__(self, other):
		return RegisterOperation("div", self, other)

	def __pow__(self, other):
		return RegisterOperation("pow", self, other)

	def __neg__(self):
		return RegisterOperation("neg", self)


class RegisterStack:
	def __init__(self, idSet):
		self.stack = list(idSet)
		self.using = set()

	def get(self):
		index = self.stack.pop()
		self.using.add(index)
		return VT(index)

	def put(self, item):
		assert item in self
		index = item.index
		self.using.remove(index)
		self.stack.append(index)

	def __contains__(self, item):
		return type(item) is VT and item.index in self.using


class RegisterOperation(Operatorable):
	def __init__(self, operator, lvalue, rvalue=None):
		self.operator = operator
		self.lvalue = lvalue
		self.rvalue = rvalue

	def depth(self):
		lflag = type(self.lvalue) is RegisterOperation
		rflag = type(self.rvalue) is RegisterOperation
		if lflag and rflag:
			return 1 + max(self.lvalue.depth(), self.rvalue.depth())
		if lflag: return 1 + self.lvalue.depth()
		if rflag: return 1 + self.rvalue.depth()
		return 1

	def assign(self, dest):
		lvalue = self.lvalue
		rvalue = self.rvalue
		lflag = type(lvalue) is RegisterOperation
		rflag = type(rvalue) is RegisterOperation
		ldepth = lvalue.depth() if lflag else 0
		rdepth = rvalue.depth() if rflag else 0

		if dest in self.stack:
			if lflag and rflag:
				if rdepth > ldepth:
					rflag = False
					rvalue = dest
					self.rvalue.assign(rvalue)
				else:
					lflag = False
					lvalue = dest
					self.lvalue.assign(lvalue)
			elif lflag:
				lflag = False
				lvalue = dest
				self.lvalue.assign(lvalue)
			elif rflag:
				rflag = False
				rvalue = dest
				self.rvalue.assign(rvalue)

		if lflag and rflag:
			if rdepth > ldepth:
				rvalue = self.stack.get()
				self.rvalue.assign(rvalue)
				lvalue = self.stack.get()
				self.lvalue.assign(lvalue)
			else:
				lvalue = self.stack.get()
				self.lvalue.assign(lvalue)
				rvalue = self.stack.get()
				self.rvalue.assign(rvalue)
		else:
			if lflag:
				lvalue = self.stack.get()
				self.lvalue.assign(lvalue)

			if rflag:
				rvalue = self.stack.get()
				self.rvalue.assign(rvalue)

		codeList.append((self.operator, dest.value(), lvalue.value(), rvalue and rvalue.value()))
		
		if rflag: self.stack.put(rvalue)
		if lflag: self.stack.put(lvalue)


class Register(Operatorable):
	def __init__(self, index, selector=None):
		self.index = index
		self.selector = selector or "xyzw"

	def value(self):
		return self

	def __str__(self):
		name = type(self).__name__.lower()
		return f"{name}{self.index}.{self.selector}"


class RegisterSlot(Operatorable):
	def __init__(self, name, index):
		object.__setattr__(self, "name", name)
		object.__setattr__(self, "index", index)

	def __getattr__(self, name):
		return self.name(self.index, name)

	def __setattr__(self, name, value):
		register = getattr(self, name)
		if type(value) is RegisterOperation:
			value.assign(register)
		else:
			mov(register, value)

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
		if slot is value: return
		if type(value) is RegisterOperation:
			value.assign(slot.xyzw)
		else:
			slot.xyzw = value

#=============================================================================

codeList = []

def mov(dest, source1):
	codeList.append(("mov", dest.value(), source1.value()))

def dp4(source1, source2):
	return RegisterOperation("dp4", source1, source2)


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


import re

def begin(file):
	with open(file) as f:
		data = f.read()
	idSet = re.findall(r"vt\[(\d+)\]", data)
	idSet = set(map(int, idSet))
	RegisterOperation.stack = RegisterStack(set(range(len(vt))) - idSet)

def end():
	print("\n".join(" ".join(map(str, item)) for item in codeList))