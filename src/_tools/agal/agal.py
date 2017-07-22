import re
import ast

register_type = ["vt", "ft", "va", "fs", "vc", "fc", "op", "oc", "v"]
__all__ = ["run"] + register_type

VERTEX = "vertex"
FRAGMENT = "fragment"

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

for key in ("rcp", "frc", "sqt", "rsq", "log", "exp", "nrm", "sin", "cos", "crs", "dp3", "dp4", "sat", "m33", "m44", "m34", "tex"):
	globals()[key] = createMethod(key)

def kil(source1): addCode("kil", None, source1)


class RegisterStack:
	def __init__(self, regType, idSet):
		self.regType = regType
		self.stack = list(idSet)
		self.using = set()

	def reset(self):
		while len(self.using):
			self.stack.append(self.using.pop())

	def get(self):
		index = self.stack.pop()
		self.using.add(index)
		return RegisterSlot(self.regType, index)
	
	def put(self, item):
		assert item in self
		index = item.index
		self.using.remove(index)
		self.stack.append(index)
	
	def __contains__(self, item):
		if type(item) is RegisterSlot:
			return item.name is self.regType and item.index in self.using
		if type(item) is self.regType:
			return item.index in self.using and item.selector == "xyzw"
		return False


class IndirectRegister(Operatorable):
	def __init__(self, index, offset, selector):
		self.index = index
		self.offset = offset
		self.selector = selector

	def value(self):
		return self

	def __str__(self):
		if self.offset:
			text = f"vc[{self.index}+{self.offset}]"
		else:
			text = f"vc[{self.index}]"
		if self.selector == "xyzw":
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
		return getattr(self, "xyzw")


class Register(Operatorable):
	def __init__(self, index, selector=None):
		self.index = index
		self.selector = selector or "xyzw"

	def value(self):
		return self

	def __str__(self):
		name = type(self).__name__.lower()
		text = f"{name}{self.index}"
		if hasattr(self, "args"):
			args = ", ".join(self.args)
			text += f"<{args}>"
		if self.selector == "xyzw":
			return text
		return f"{text}.{self.selector}"


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

	def group(self):
		return globals()[self.name.__name__.lower()]

	def __call__(self, *args):
		assert self.name is FS
		reg = self.value()
		reg.args = args
		return reg



class RegisterGroup:
	def __init__(self, name, count):
		self.group = [RegisterSlot(name, i) for i in range(count)]
		self.count = count
		if name in (VC, FC):
			self.const = [None] * count
		if name in (VA, FS):
			self.usage = 0
		if name in (VC, FC, VA, FS):
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
		return self.group[key]

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
		slot = self.group[key]
		if value in regStack:
			updateLastCode(slot)
		else:
			slot.xyzw = value
		regStack.reset()

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

	def numToReg(self, value):
		for index, v in enumerate(self.const):
			if v is None: continue
			try:
				offset = v.index(value)
			except ValueError:
				continue
			break
		else:
			if not hasattr(self, "numIndex"):
				self.numIndex = self.nextNumRegIndex()
				self.numDigit = []

			index = self.numIndex
			offset = len(self.numDigit)

			self.numDigit.append(value)

			if not self.useInfo[index]:
				self.useInfo[index] = True
				self.const[index] = self.numDigit

			if len(self.numDigit) == 4:
				del self.numIndex
		return getattr(nowConstReg[index], "xyzw"[offset])



#=============================================================================
def addCode(op, dest, source1, source2=None):
	if type(source1) in (int, tuple):
		source1 = nowConstReg.numToReg(source1)
	if type(source2) in (int, tuple):
		source2 = nowConstReg.numToReg(source2)
	codeList.append([op, dest and dest.value(), source1.value(), source2 and source2.value()])

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
class V(Register): pass


TEMP_REG_COUNT = 8

vt = RegisterGroup(VT, TEMP_REG_COUNT)
ft = RegisterGroup(FT, TEMP_REG_COUNT)
vc = RegisterGroup(VC, 128)
fc = RegisterGroup(FC, 64)
va = RegisterGroup(VA, 8)
fs = RegisterGroup(FS, 8)
op = RegisterGroup(OP, 1)
oc = RegisterGroup(OC, 1)
v  = RegisterGroup(V , 8)


def run(context):
	ExecContext.context = context
	begin(context["__file__"])


	for k, v in enumerate(vc.const):
		if v is None: continue
		print(k, v)
	for k, v in enumerate(fc.const):
		if v is None: continue
		print(k, v)
	#print("va usage", va.usage)
	#print("fs usage", fs.usage)

def begin(file):
	with open(file) as f:
		data = f.read()
	syntaxTree = ast.parse(data)
	runCode(data, syntaxTree, VERTEX)
	end()
	runCode(data, syntaxTree, FRAGMENT)
	end()

def end():
	print("\n".join(" ".join(str(key) for key in item if key is not None) for item in codeList))
	print()
	#input()

def callNode(tree, name):
	for node in tree.body:
		if type(node) is ast.FunctionDef and node.name == name:
			break
	else: assert False, f"{name}() not found!"
	code = ast.Module(node.body)
	code = compile(code, "<string>", "exec")
	exec(code, None, ExecContext())

def runCode(data, tree, name):
	global regStack, nowConstReg
	if name == VERTEX:
		regType = VT
		nowConstReg = vc
	else:
		regType = FT
		nowConstReg = fc
	nowConstReg.calcUsedInfo()
	idSet = re.findall(name[0] + r"t\[(\d+)\]", data)
	idSet = set(map(int, idSet))
	regStack = RegisterStack(regType, set(range(TEMP_REG_COUNT)) - idSet)
	codeList.clear()
	callNode(tree, name)

REG_PATTERN = re.compile(r"^(va|fs|vt|ft|vc|fc|op|oc|v)(\d+)$")

class ExecContext(dict):
	def __init__(self):
		super().__init__(type(self).context)

	def __getitem__(self, key):
		if key not in self:
			mt = REG_PATTERN.match(key)
			if mt: return globals()[mt[1]][int(mt[2])]
		return super().__getitem__(key)

	def __setitem__(self, key, value):
		if key in self:
			target = self[key]
			if type(target) is RegisterSlot:
				target.group()[target.index] = value
				return
		else:
			mt = REG_PATTERN.match(key)
			if mt:
				globals()[mt[1]][int(mt[2])] = value
				return
		super().__setitem__(key, value)
		