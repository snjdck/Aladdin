__all__ = ("Inject", "Injector")

class Inject:
	__slots__ = ("type", "id")
	def __init__(self, type, id=None):
		self.type = type
		self.id = id

class InjectionTypeValue:
	def __init__(self, realInjector, value):
		self.realInjector = realInjector
		self.value = value

	def getValue(self, injector, id):
		if self.realInjector is not None:
			injector = self.realInjector
			self.realInjector = None
			injector.injectInto(self.value)
		return self.value

class InjectionTypeClass:
	def __init__(self, realInjector, klass):
		self.realInjector = realInjector
		self.klass = klass

	def getValue(self, injector):
		value = self.klass()
		self.realInjector.injectInto(value)
		return value

class InjectionTypeSingleton:
	def __init__(self, realInjector, klass):
		self.realInjector = realInjector
		self.klass = klass
		self.value = None

	def getValue(self, injector):
		if self.value is None:
			self.value = self.klass()
			self.realInjector.injectInto(self.value)
			self.realInjector = None
			self.klass = None
		return self.value

class Injector:
	__slots__ = ("ruleDict", "parent")
	def __init__(self):
		self.ruleDict = {}
		self.parent = None

	@staticmethod
	def calcKey(type, id=None, isMeta=False):
		key = type if isinstance(type, str) else type.__name__
		return f"{key}@" if isMeta else f"{key}@{id}" if id else key

	def mapValue(self, type, value, id=None, needInject=True, realInjector=None):
		self.mapRule(type, InjectionTypeValue(realInjector or self if needInject else None, value), id)

	def mapClass(self, type, value=None, id=None, realInjector=None):
		self.mapRule(type, InjectionTypeClass(realInjector or self, value or type), id)

	def mapSingleton(self, type, value=None, id=None, realInjector=None):
		self.mapRule(type, InjectionTypeSingleton(realInjector or self, value or type), id)

	def mapRule(self, type, rule, id=None):
		self.ruleDict[self.calcKey(type, id)] = rule

	def mapMetaRule(self, type, rule):
		self.ruleDict[self.calcKey(type, isMeta=True)] = rule

	def unmap(self, type, id=None):
		del self.ruleDict[self.calcKey(type, id)]

	def getRule(self, key, inherit=True):
		injector = self
		while injector:
			rule = injector.ruleDict.get(key)
			if not inherit or rule: break
			injector = injector.parent
		return rule

	def getInstance(self, type, id=None):
		rule = self.getRule(self.calcKey(type, id)) or self.getRule(self.calcKey(type, isMeta=True))
		return rule and rule.getValue(self, id)

	def injectInto(self, target):
		queue = [target.__class__]
		while len(queue):
			klass = queue.pop(0)
			queue += klass.__bases__
			if not hasattr(klass, "__annotations__"):
				continue
			for k, v in klass.__annotations__.items():
				value = self.getInstance(v.type) if isinstance(v, Inject) else None
				setattr(target, k, value)
