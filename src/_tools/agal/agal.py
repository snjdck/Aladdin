import re

class VT_:
	def __init__(self, index, selector):
		self.index = index
		self.selector = selector

	def value(self):
		return self

	def __str__(self):
		return f"vt{self.index}.{self.selector}"


class Register:
	def __init__(self, index):
		object.__setattr__(self, "index", index)

	def __getattr__(self, name):
		key = type(self).__name__ + "_"
		return globals()[key](self.index, name)

	def __setattr__(self, name, value):
		mov(getattr(self, name), value)

	def value(self):
		return getattr(self, "xyzw")


class RegisterGroup:
	def __init__(self, count):
		key = re.match("[a-z]+", type(self).__name__, re.I)[0]
		self.group = [globals()[key](i) for i in range(count)]

	def __getitem__(self, key):
		return self.group[key]

	def __setitem__(self, key, value):
		self.group[key].xyzw = value

class VT(Register): pass
class VT_GROUP(RegisterGroup): pass


def mov(dest, source1):
	print(dest.value(), source1.value())


vt = VT_GROUP(8)

vt[0].x = vt[3]
vt[0] = vt[4].z
mov(vt[0], vt[1])
input()
'''
vt[0].x = dp4(vt[0], vc[1])
vt[1] = dp4(vt[0], vt[2])
'''