
class Register:
	def __init__(self, index, selector):
		self.index = index
		self.selector = selector

	def value(self):
		return self

	def __str__(self):
		name = type(self).__name__.lower()
		return f"{name}{self.index}.{self.selector}"


class RegisterSlot:
	def __init__(self, name, index):
		object.__setattr__(self, "name", name)
		object.__setattr__(self, "index", index)

	def __getattr__(self, name):
		return self.name(self.index, name)

	def __setattr__(self, name, value):
		mov(getattr(self, name), value)

	def value(self):
		return getattr(self, "xyzw")


class RegisterGroup:
	def __init__(self, name, count):
		self.group = [RegisterSlot(name, i) for i in range(count)]

	def __getitem__(self, key):
		return self.group[key]

	def __setitem__(self, key, value):
		self.group[key].xyzw = value



def mov(dest, source1):
	print(dest.value(), source1.value())


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

vt[0].x = vt[3]
vt[0] = vt[4].z
mov(vt[0], vt[1])
input()
'''
vt[0].x = dp4(vt[0], vc[1])
vt[1] = dp4(vt[0], vt[2])
'''