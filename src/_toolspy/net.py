
__all__ = ("msgid", "NetMsgHandler")

def msgid(value):
	def wrapper(handler):
		handler.value = value
		return handler
	return wrapper

class Dict(dict):
	def __setitem__(self, key, value):
		assert key not in self, key
		super().__setitem__(key, value)

class NetMsgHandlerMetaClass(type):
	def __prepare__(name, bases):
		return Dict()

	def __new__(cls, name, bases, attributes):
		msgIdDict = Dict()
		for k, v in attributes.items():
			if k.startswith("__"):
				continue
			v.name = f"{name}.{k}"
			msgIdDict[v.value] = v
		result = type.__new__(cls, name, bases, attributes)
		result.msgIdDict = msgIdDict
		return result

class NetMsgHandler(metaclass=NetMsgHandlerMetaClass):
	def __new__(cls, value):
		return cls.msgIdDict.get(value)

class Test(NetMsgHandler):
	@msgid(5)
	def fuck(socket, packet):
		pass

	@msgid(6)
	def fucks():
		pass

print(Test.fuck.name)
print(Test.fuck.value)
print(Test(7))