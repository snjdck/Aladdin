__all__ = ("Inject", "Injector")

class Inject:
	__slots__ = ("type", "id")
	def __init__(self, type, id=None):
		self.type = type
		self.id = id

	def getInstance(self, injector):
		return injector.getInstance(self.type, self.id)

class InjectionTypeValue:
	def __init__(self, realInjector, value):
		self.realInjector = realInjector
		self.value = value

	def getValue(self, injector, id):
		if self.realInjector:
			injector = self.realInjector
			self.realInjector = None
			injector.injectInto(self.value)
		return self.value

class InjectionTypeClass:
	def __init__(self, realInjector, klass):
		self.realInjector = realInjector
		self.klass = klass

	def getValue(self, injector, id):
		value = self.klass()
		self.realInjector.injectInto(value)
		return value

class InjectionTypeSingleton:
	def __init__(self, realInjector, klass):
		self.realInjector = realInjector
		self.klass = klass
		self.value = None

	def getValue(self, injector, id):
		if self.value is None:
			self.value = self.klass()
			self.realInjector.injectInto(self.value)
			self.realInjector = None
			self.klass = None
		return self.value

def calcKey(type, id=None, isMeta=False):
	key = type if isinstance(type, str) else type.__qualname__
	return f"{key}@" if isMeta else f"{key}@{id}" if id else key

def castKey(key):
	if isinstance(key, slice):
		return calcKey(key.start, key.stop)
	return calcKey(key, isMeta=True)

class Injector:
	__slots__ = ("ruleDict", "parent")
	def __init__(self):
		self.ruleDict = {}
		self.parent = None

	def mapValue(self, type, value, id=None, realInjector=True):
		if realInjector is True: realInjector = self
		self[type:id] = InjectionTypeValue(realInjector, value)

	def mapClass(self, type, value=None, id=None, realInjector=None):
		self[type:id] = InjectionTypeClass(realInjector or self, value or type)

	def mapSingleton(self, type, value=None, id=None, realInjector=None):
		self[type:id] = InjectionTypeSingleton(realInjector or self, value or type)

	def mapRule(self, type, rule, id=None):
		self[type:id] = rule

	def mapMetaRule(self, type, rule):
		self[type] = rule

	def unmap(self, type, id=None):
		del self[type:id]

	def getRule(self, key, inherit=True):
		injector = self
		while injector:
			rule = injector.ruleDict.get(key)
			if not inherit or rule: break
			injector = injector.parent
		return rule

	def getInstance(self, type, id=None):
		rule = self.getRule(calcKey(type, id)) or self.getRule(calcKey(type, isMeta=True))
		return rule and rule.getValue(self, id)

	def injectInto(self, target):
		queue = [target.__class__]
		while len(queue):
			klass = queue.pop(0)
			queue += klass.__bases__
			if not hasattr(klass, "__annotations__"):
				continue
			for k, v in klass.__annotations__.items():
				value = v.getInstance(self) if isinstance(v, Inject) else None
				setattr(target, k, value)
		self.invoke(target, "__inject__")

	def invoke(self, target, name):
		if not hasattr(target, name):
			return
		func = getattr(target, name)
		attr = func.__annotations__
		code = func.__code__
		args = code.co_varnames[1:code.co_argcount]
		func(*[self[attr[k]] for k in args])

	def __getitem__(self, key):
		if isinstance(key, slice):
			return self.getInstance(key.start, key.stop)
		if isinstance(key, type):
			return self.getInstance(key)
		return [self[k] for k in key]

	def __setitem__(self, key, value):
		self.ruleDict[castKey(key)] = value

	def __delitem__(self, key):
		del self.ruleDict[castKey(key)]

	def __rshift__(self, target):
		self.injectInto(target)
		return self

	def __call__(self, target):
		self.injectInto(target)
		return target
