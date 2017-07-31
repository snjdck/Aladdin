import builtins, traceback, sys, operator, functools

__all__  = ["run", "input", "const", "xt"]
__all__ += ["min", "max", "rcp", "frc", "sqt", "rsq", "log", "exp", "nrm", "sin", "cos", "crs", "dp3", "dp4", "sat", "m33", "m44", "m34", "tex", "ddx", "ddy", "kil", "ife", "ine", "ifg", "ifl", "els", "eif"]

VERTEX = "vertex"
FRAGMENT = "fragment"
XYZW = "xyzw"

def createMethod(name):
	def func(self, other=None):
		slot = self if self in tempStack else other if other in tempStack else tempStack.get()
		addCode(name, slot, self, other)
		return slot
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

class TempStack:
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
	def __init__(self, name, index=0):
		super().__setattr__("name", name)
		super().__setattr__("index", index)

	def __getattr__(self, name):
		return self.name(self, name)

	def __setattr__(self, name, value):
		assert self.writable()
		register = getattr(self, name)
		if value in tempStack:
			updateLastCode(register)
		elif str(register) != str(value):
			addCode("mov", register, value)

	def value(self):
		return str(getattr(self, XYZW))

	def writable(self):
		return self.name in (XT, XO, V)

	def __imatmul__(self, value):
		if value in tempStack:
			assert self.writable()
			updateLastCode(self)
		else:
			self.xyzw = value
		return self

	def __del__(self):
		if self.name is XT:
			tempStack.put(self.index)

class Dict(dict):
	def __setitem__(self, key, value):
		assert key not in self, key
		super().__setitem__(key, value)

class ConstRegister:
	def __getitem__(self, key):
		if isinstance(key, Register):
			return IndirectRegisterSlot(key)
		if isinstance(key, slice):
			return IndirectRegisterSlot(key.start, key.stop)
		assert False

class ConstStack:
	def __init__(self, handler, count):
		self.group = [RegisterSlot(XC, i) for i in range(count)]
		self.count = count
		self.const = [None] * count
		self.offset = handler.offset
		handler.data = self.const

	@staticmethod
	def calcSelectorInSlot(slot, value):
		return "".join(map(XYZW.__getitem__, [0 if v is None else slot.index(v) for v in value]))

	def nextValueRegisterIndex(self):
		index = builtins.max(-1 if v is None else i for i, v in enumerate(self.const)) + 1
		index = builtins.max(index, self.offset)
		assert index < self.count
		return index

	def findRegister(self, index, value):
		return getattr(self.group[index], self.calcSelectorInSlot(self.const[index], value))

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

def input_callback(handler, kwargs):
	assert len(kwargs) <= 8
	RegisterType = VA if handler.__name__ == VERTEX else FS
	for index, key in enumerate(kwargs):
		slot = RegisterSlot(RegisterType, index)
		handler.input[key] = (index, kwargs[key])
		if RegisterType is FS:
			slot = getattr(slot, XYZW)
			slot.args = kwargs[key]
		else: assert kwargs[key] in ("bytes4", "float1", "float2", "float3", "float4")
		handler.field[key] = slot

def const_callback(handler, kwargs):
	index = 0
	for k, v in kwargs.items():
		slot = RegisterSlot(XC, index)
		handler.const[k] = (index, index + v)
		for i in range(v):
			handler.field[f"{k}{i}"] = RegisterSlot(XC, index+i)
		handler.field[k] = slot
		index += v
	handler.offset = index

def createAttribute(name, callback):
	def attribute(**kwargs):
		def wrapper(handler):
			assert handler.__name__ in (VERTEX, FRAGMENT)
			assert not hasattr(handler, name)
			setattr(handler, name, {})
			if not hasattr(handler, "field"):
				handler.field = Dict()
			callback(handler, kwargs)
			return handler
		return wrapper
	return attribute

input = createAttribute("input", input_callback)
const = createAttribute("const", const_callback)
#=============================================================================
def addCode(op, dest, source1, source2=None):
	if type(source1) in (int, float):
		for a, b, c in [("sub", 0, "neg"), ("div", 1, "rcp"), ("pow", 2, "exp")]:
			if op == a and source1 == b:
				codeList.append([c, dest.value(), source2.value()])
				return
		if op == "mul" and source1 == 2:
			addCode(op, dest, source2, 2)
			return
	elif type(source2) in (int, float) and source2 == 2:
		for a, b in [("mul", "add"), ("pow", "mul")]:
			if op == a:
				codeList.append([b, dest.value(), source1.value(), source1.value()])
				return
	if type(source1) in (int, float, tuple):
		source1 = constStack.valueToRegister(source1)
	elif type(source2) in (int, float, tuple):
		source2 = constStack.valueToRegister(source2)
	codeList.append([op, dest and dest.value(), source1.value(), source2 and source2.value()])

def updateLastCode(dest):
	codeList[-1][1] = dest.value()

codeList = []
#=============================================================================
for key in ("XT", "XC", "XO", "VA", "FS", "V"):
	globals()[key] = type(key, (Register,), dict())

tempStack = TempStack(8)
xt = lambda: tempStack.get(False)

def run(handler):
	global constStack, varying
	assert handler.__name__ in (VERTEX, FRAGMENT)

	for k, v in (("field", {}), ("input", {}), ("const", {}), ("offset", 0)):
		if not hasattr(handler, k):
			setattr(handler, k, v)

	field = handler.field

	if handler.__name__ == VERTEX:
		argcount = handler.__code__.co_argcount
		argnames = handler.__code__.co_varnames[1:argcount]
		varying = [RegisterSlot(V, i) for i in range(len(argnames))]
		field["vc"] = ConstRegister()
		args = [RegisterSlot(XO)] + varying
		constStack = ConstStack(handler, 128)
		varying = zip(argnames, varying)
	else:
		field.update(dict(varying))
		args = [RegisterSlot(XO)]
		constStack = ConstStack(handler, 64)
	
	_globals = handler.__globals__
	assert all(k not in _globals for k in field)
	_globals.update(field)

	try:
		handler(*args)
	except:
		error = sys.exc_info()
		print("".join(traceback.format_list(traceback.extract_tb(error[2])[1:])) + error[0].__name__ + ": " + str(error[1]))
	else:
		print("\n".join(" ".join(str(key) for key in item if key is not None) for item in codeList))
	finally:
		[_globals.__delitem__(k) for k in field]
		codeList.clear()
		print()

	a, b = constStack.offset, constStack.nextValueRegisterIndex()
	handler.data = functools.reduce(operator.add, handler.data[a:b], [])

	del handler.field
	return handler.__dict__
