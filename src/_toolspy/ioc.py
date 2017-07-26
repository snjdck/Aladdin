__all__ = ["inject", "Injector"]
INJECT_KEY = "__inject__"

def inject(name, **kwargs):
	def wrapper(clazz):
		if not hasattr(clazz, INJECT_KEY):
			setattr(clazz, INJECT_KEY, {})
		getattr(clazz, INJECT_KEY)[name] = kwargs
		return clazz
	return wrapper


class InjectionTypeValue:
	def __init__(self, value):
		self.value = value

	def getValue(self, injector):
		return self.value


class InjectionTypeClass:
	def __init__(self, clazz):
		self.clazz = clazz

	def getValue(self, injector):
		value = self.clazz()
		injector.injectInto(value)
		return value


class InjectionTypeSingleton:
	def __init__(self, clazz):
		self.clazz = clazz
		self.value = None

	def getValue(self, injector):
		if not self.value:
			self.value = self.clazz()
			injector.injectInto(self.value)
		return self.value


class Injector:
	def __init__(self):
		self.parent = None
		self.ruleDict = {}

	def mapValue(self, key, value):
		key = key.__name__
		self.ruleDict[key] = InjectionTypeValue(value)

	def mapClass(self, key, value=None):
		value = value or key
		key = key.__name__
		self.ruleDict[key] = InjectionTypeClass(value)

	def mapSingleton(self, key, value=None):
		value = value or key
		key = key.__name__
		self.ruleDict[key] = InjectionTypeSingleton(value)

	def getInstance(self, key):
		key = key.__name__
		rule = self.ruleDict.get(key)
		return rule.getValue(self) if rule else None

	def injectInto(self, target):
		queue = [target.__class__]
		while len(queue):
			clazz = queue.pop(0)
			queue += clazz.__bases__
			if not hasattr(clazz, INJECT_KEY): continue
			for key, value in getattr(clazz, INJECT_KEY).items():
				value = self.getInstance(value["type"])
				setattr(target, key, value)
			
