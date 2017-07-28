import builtins, traceback, sys

__all__  = ["run"]
__all__ += ["vt", "ft", "va", "fs", "vc", "fc", "op", "oc", "v"]
__all__ += ["min", "max", "rcp", "frc", "sqt", "rsq", "log", "exp", "nrm", "sin", "cos", "crs", "dp3", "dp4", "sat", "m33", "m44", "m34", "tex", "ddx", "ddy", "kil", "ife", "ine", "ifg", "ifl", "els", "eif"]
__all__ += ["BYTES_4", "FLOAT_1", "FLOAT_2", "FLOAT_3", "FLOAT_4", "Matrix"]

VERTEX = "vertex"
FRAGMENT = "fragment"
XYZW = "xyzw"

BYTES_4 = "bytes4"
FLOAT_1 = "float1"
FLOAT_2 = "float2"
FLOAT_3 = "float3"
FLOAT_4 = "float4"

class Matrix:
	def __init__(self, count):
		self.count = count

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
	_i = lambda f: lambda a, b: a.__imatmul__(f(a, b))
	__iadd__	= _i(__add__)
	__isub__	= _i(__sub__)
	__imul__	= _i(__mul__)
	__itruediv__= _i(__truediv__)
	__ipow__	= _i(__pow__)

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

	def get(self, useFlag=True):
		index = self.stack.pop(0)
		if useFlag: self.using.add(index)
		return RegisterSlot(XT, index)
	
	def put(self, index):
		self.stack.append(index)
		self.stack.sort()
		if index in self.using:
			self.using.remove(index)
	
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
		elif str(register) != str(value):
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
			regStack.put(self.index)

class RegisterGroup:
	field = {}

	def __init__(self, name, count):
		self.group = [RegisterSlot(name, i) for i in range(count)]
		self.count = count
		if name is XC:
			self.const = [None] * count
		if name in (VA, FS):
			self.usage = 0
		if name in (XC, VA, FS):
			self.field = {}

	def __getitem__(self, key):
		if isinstance(key, Register):
			return IndirectRegisterSlot(key)
		if isinstance(key, slice):
			return IndirectRegisterSlot(key.start, key.stop)
		assert type(key) is int
		slot = self.group[key]
		assert slot.name not in (XC, VA, FS), f"{slot.value()} has not declared!"
		return slot

	def __setitem__(self, key, value):
		assert type(key) is int
		self.group[key] @= value

	def __call__(self, **kwargs):
		assert not hasattr(self, "extra")
		self.extra = kwargs
		count = len(kwargs)
		if hasattr(self, "usage"):
			self.usage = (1 << count) - 1
		ClassField = type(self).field
		index = 0
		for k, v in kwargs.items():
			slot = self.group[index]
			self.field[k] = index
			if slot.name is XC:
				for i in range(v.count):
					ClassField[f"{k}{i}"] = self.group[index+i]
			if slot.name is FS:
				slot = getattr(slot, XYZW)
				slot.args = v
			ClassField[k] = slot
			index += v.count if type(v) is Matrix else 1

	def nextValueRegisterIndex(self):
		count = sum(v.count if type(v) is Matrix else 1 for v in self.extra.values()) if hasattr(self, "extra") else 0
		index = builtins.max(-1 if v is None else i for i, v in enumerate(self.const)) + 1
		index = builtins.max(index, count)
		assert index < self.count
		return index

	def findRegister(self, index, value):
		slot = self.const[index]
		selector = calcSelectorInSlot(slot, value)
		return getattr(self.group[index], selector)

	def valueToRegister(self, value):
		if type(value) in (int, float): value = (value,)
		assert type(value) is tuple and len(value) <= 4
		valueSet = set(v for v in value if v is not None)
		for index, slot in enumerate(self.const):
			if slot is None: continue
			if all(v in slot for v in valueSet):
				return self.findRegister(index, value)
		index = self.nextValueRegisterIndex()
		if index > 0:
			slot = self.const[index-1]
			if slot is not None and len(slot) + len(valueSet) <= 4:
				slot += valueSet
				return self.findRegister(index-1, value)
		self.const[index] = list(valueSet)
		return self.findRegister(index, value)
		
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
	elif type(source2) in (int, float):
		if op == "mul" and source2 == 2:
			codeList.append(["add", dest.value(), source1.value(), source1.value()])
			return
		if op == "pow" and source2 == 2:
			codeList.append(["mul", dest.value(), source1.value(), source1.value()])
			return
	if type(source1) in (int, float, tuple):
		source1 = nowConstReg.valueToRegister(source1)
	elif type(source2) in (int, float, tuple):
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

vt = ft = xt = lambda: regStack.get(False)
vc = RegisterGroup(XC, 128)
fc = RegisterGroup(XC, 64)
va = RegisterGroup(VA, 8)
fs = RegisterGroup(FS, 8)
op = RegisterGroup(OP, 1)
oc = RegisterGroup(OC, 1)
v  = RegisterGroup(V , 8)

regStack = RegisterStack(8)

def run(handler):
	global nowConstReg
	nowConstReg = vc if handler.__name__ == VERTEX else fc

	handler.__globals__.update(RegisterGroup.field)
	try:
		handler()
	except:
		error = sys.exc_info()
		print("".join(traceback.format_list(traceback.extract_tb(error[2])[1:])) + error[0].__name__ + ": " + str(error[1]))
	else:
		print("\n".join(" ".join(str(key) for key in item if key is not None) for item in codeList))
	finally:
		codeList.clear()
		print()
