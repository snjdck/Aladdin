'''
def inject(name: str, **kwargs):
	if not hasattr(inject, "__inject__"):
		inject.__inject__ = {}
	injectionDict = inject.__inject__
	def wrapper(func):
		clazz = func.__qualname__
		if clazz not in injectionDict:
			injectionDict[clazz] = {}
		injectionDict[clazz][name] = kwargs
		return func
	return wrapper


class InjectionTypeValue:
	def __init__(self, value):
		self.value = value

	def getValue(self, injector):
		return self.value


class Injector:
	def __init__(self):
		self.parent = None
		self.ruleDict = {}

	def mapValue(self, key, value):
		key = key.__name__
		self.ruleDict[key] = InjectionTypeValue(value)

	def getInstance(self, key):
		key = key.__name__
		rule = self.ruleDict.get(key)
		return rule.getValue(self) if rule else None

	def injectInto(self, target):
		info = inject.__inject__[target.__class__.__name__]
		for key in info:
			value = self.getInstance(info[key]["type"])
			setattr(target, key, value)
'''
from ioc import *
class Dum: pass

@inject("test", id="a", type=Dum)
@inject("aaaa", id="b", type=list)
class Test:
	pass
#	@inject(id="a", type=Dum)
#	def test(): pass

injector = Injector()
injector.mapValue(Dum, Dum())

t = Test()

injector.injectInto(t)
print(t.test, t.aaaa)
#print(t.test)
input()
