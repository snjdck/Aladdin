
register_type = ["vt", "ft", "va", "fs", "vc", "fc", "op", "oc", "v"]
__all__ = ["run"] + register_type + ["min", "max", "rcp", "frc", "sqt", "rsq", "log", "exp", "nrm", "sin", "cos", "crs", "dp3", "dp4", "sat", "m33", "m44", "m34", "tex", "ddx", "ddy", "kil", "ife", "ine", "ifg", "ifl", "els", "eif"]

VERTEX = "vertex"
FRAGMENT = "fragment"
XYZW = "xyzw"

def createMethod(name):
	def func(self, other=None):
		if self in regStack:
			reg = self
		elif other in regStack:
			reg = other
		else:
			reg = regStack.get()
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
	__eq__		= createMethod("seq")
	__ne__		= createMethod("sne")
	__lt__		= createMethod("slt")
	__ge__		= createMethod("sge")
	__abs__		= createMethod("abs")
	_r = lambda f: lambda a, b: f(b, a)
	__radd__	= _r(__add__)
	__rsub__	= _r(__sub__)
	__rmul__	= _r(__mul__)
	__rtruediv__= _r(__truediv__)
	__rpow__	= _r(__pow__)
	__le__		= _r(__ge__)
	__gt__		= _r(__lt__)

for key in ("min", "max", "rcp", "frc", "sqt", "rsq", "log", "exp", "nrm", "sin", "cos", "crs", "dp3", "dp4", "sat", "m33", "m44", "m34", "tex", "ddx", "ddy"):
	globals()[key] = createMethod(key)

def kil(source1): addCode("kil", None, source1)
def ife(source1): addCode("ife", None, source1)
def ine(source1): addCode("ine", None, source1)
def ifg(source1): addCode("ifg", None, source1)
def ifl(source1): addCode("ifl", None, source1)
def els()		: codeList.append(["els"])
def eif()		: codeList.append(["eif"])

def calcSelectorInSlot(slot, value):
	selector = [0 if v is None else slot.index(v) for v in value]
	selector = "".join(map(XYZW.__getitem__, selector))
	return selector

class RegisterStack:
	def __init__(self, count):
		self.stack = list(range(count))
		self.using = set()

	def get(self):
		index = self.stack.pop(0)
		self.using.add(index)
		return RegisterSlot(XT, index)
	
	def put(self, item):
		assert item in self
		index = item.index
		self.using.remove(index)
		self.stack.append(index)
		self.stack.sort()
	
	def __contains__(self, item):
		if type(item) is RegisterSlot:
			return item.name is XT and item.index in self.using
		if type(item) is XT:
			return item.index in self.using and item.selector == XYZW
		return False


class IndirectRegister(Operatorable):
	def __init__(self, index, offset, selector):
		self.index = index
		self.offset = offset
		self.selector = selector

	def value(self):
		return str(self)

	def __str__(self):
		if self.offset:
			text = f"vc[{self.index}+{self.offset}]"
		else:
			text = f"vc[{self.index}]"
		if self.selector == XYZW:
			return text
		return f"{text}.{self.selector}"


class IndirectRegisterSlot(Operatorable):
	def __init__(self, index, offset=0):
		assert isinstance(index, Register)
		assert len(index.selector) == 1
		self.index = index
		self.offset = offset

	def __getattr__(self, name):
		return IndirectRegister(self.index, self.offset, name)

	def value(self):
		return str(getattr(self, XYZW))


class Register(Operatorable):
	def __init__(self, slot, selector=None):
		self.slot = slot
		self.index = slot.index
		self.selector = selector or XYZW

	def __imatmul__(self, value):
		setattr(self.slot, self.selector, value)
		return self

	def value(self):
		return str(self)

	def __next__(self):
		assert len(self.selector) == 1
		return self.__class__(self.slot, XYZW["wxyz".index(self.selector)])

	def __str__(self):
		name = type(self).__name__.lower()
		text = f"{name}{self.index}"
		if hasattr(self, "args"):
			args = ", ".join(self.args)
			text += f"<{args}>"
		if self.selector == XYZW:
			return text
		return f"{text}.{self.selector}"


class RegisterSlot(Operatorable):
	def __init__(self, name, index):
		object.__setattr__(self, "name", name)
		object.__setattr__(self, "index", index)

	def __getattr__(self, name):
		return self.name(self, name)

	def __setattr__(self, name, value):
		assert self.writable()
		register = getattr(self, name)
		if value in regStack:
			updateLastCode(register)
		else:
			addCode("mov", register, value)

	def value(self):
		return str(getattr(self, XYZW))

	def writable(self):
		return self.name in (XT, OP, OC, V)

	def __imatmul__(self, value):
		if value in regStack:
			assert self.writable()
			updateLastCode(self)
		else:
			self.xyzw = value
		return self

	def __del__(self):
		if self.name is XT:
			regStack.put(self)

	def __call__(self, *args):
		assert self.name is FS
		reg = getattr(self, XYZW)
		reg.args = args
		return reg



class RegisterGroup:
	def __init__(self, name, count):
		self.group = [RegisterSlot(name, i) for i in range(count)]
		self.count = count
		if name is XC:
			self.const = [None] * count
		if name in (XT, VA, FS):
			self.usage = 0
		if name in (XC, VA, FS):
			self.field = {}

	def __len__(self):
		return self.count

	def __getitem__(self, key):
		if isinstance(key, Register):
			return IndirectRegisterSlot(key)
		if isinstance(key, slice):
			return IndirectRegisterSlot(key.start, key.stop)
		assert type(key) is int
		if hasattr(self, "usage"):
			self.usage |= 1 << key
		slot = self.group[key]
		self.check(slot)
		return slot

	def __setitem__(self, key, value):
		if type(value) in (tuple, list):
			assert type(key) is int
			assert len(value) == 4
			self.const[key] = value
			return
		if type(value) is str:
			assert type(key) in (int, slice)
			self.field[value] = key
			return
		assert type(key) is int
		self.group[key] @= value

	def check(self, slot):
		if slot.name is XC:
			assert self.useInfo[slot.index]
		if slot.name in (VA, FS):
			assert slot.index in self.field.values()

	def printUseInfo(self):
		print([k for k, v in enumerate(self.useInfo) if v])

	def calcUsedInfo(self):
		useInfo = [False] * len(self)
		for k, v in enumerate(self.const):
			if v is None: continue
			useInfo[k] = True
		for v in self.field.values():
			if type(v) is slice:
				for i in range(v.start, v.stop):
					useInfo[i] = True
				continue
			if type(v) is int:
				useInfo[v] = True
				continue
			assert False
		self.useInfo = useInfo
		

	def nextNumRegIndex(self):
		for index in reversed(range(len(self))):
			if self.useInfo[index]: break
		else: return 0
		index += 1
		assert index < len(self)
		return index

	def findRegister(self, index, value):
		slot = self.const[index]
		selector = calcSelectorInSlot(slot, value)
		return getattr(self.group[index], selector)

	def valueToRegister(self, value):
		if type(value) in (int, float):
			value = (value,)
		assert type(value) is tuple
		for index, slot in enumerate(self.const):
			if slot is None: continue
			if all(v in slot for v in value if v is not None):
				return self.findRegister(index, value)
		index = self.nextNumRegIndex()
		if index > 0:
			slot = self.const[index-1]
			if slot is not None and len(slot) + len(value) <= 4:
				slot += value
				return self.findRegister(index-1, value)
		self.useInfo[index] = True
		self.const[index] = list(value)
		return self.group[index]
		
		



#=============================================================================
def addCode(op, dest, source1, source2=None):
	if type(source1) in (int, float):
		if op == "sub" and source1 == 0:
			codeList.append(["neg", dest.value(), source2.value()])
			return
		if op == "div" and source1 == 1:
			codeList.append(["rcp", dest.value(), source2.value()])
			return
		if op == "pow" and source1 == 2:
			codeList.append(["exp", dest.value(), source2.value()])
			return
		if op == "mul" and source1 == 2:
			codeList.append(["add", dest.value(), source2.value(), source2.value()])
			return
	if type(source2) in (int, float):
		if op == "mul" and source2 == 2:
			codeList.append(["add", dest.value(), source1.value(), source1.value()])
			return
		if op == "pow" and source2 == 2:
			codeList.append(["mul", dest.value(), source1.value(), source1.value()])
			return
	if type(source1) in (int, float, tuple):
		source1 = nowConstReg.valueToRegister(source1)
	if type(source2) in (int, float, tuple):
		source2 = nowConstReg.valueToRegister(source2)
	codeList.append([op, dest and dest.value(), source1.value(), source2 and source2.value()])

def updateLastCode(dest):
	codeList[-1][1] = dest.value()

codeList = []

#=============================================================================

class XT(Register): pass
class XC(Register): pass
class VA(Register): pass
class FS(Register): pass
class OP(Register): pass
class OC(Register): pass
class V(Register): pass


vt = ft = xt = lambda: regStack.get()
vc = RegisterGroup(XC, 128)
fc = RegisterGroup(XC, 64)
va = RegisterGroup(VA, 8)
fs = RegisterGroup(FS, 8)
op = RegisterGroup(OP, 1)
oc = RegisterGroup(OC, 1)
v  = RegisterGroup(V , 8)

regStack = RegisterStack(8)

def run(data, handler):
	name = handler.__name__
	global nowConstReg
	if name == VERTEX:
		nowConstReg = vc
	else:
		nowConstReg = fc
	nowConstReg.calcUsedInfo()

	handler()
	
	print("\n".join(" ".join(str(key) for key in item if key is not None) for item in codeList))
	print()
	codeList.clear()
