
__all__ = ("msgid", "NetMsgHandler")

def msgid(value):
	def wrapper(handler):
		handler.value = value
		return handler
	return wrapper

class Dict(dict):
	def __setitem__(self, key, value):
		assert key not in self, f"{key}@({value.__qualname__},{value.value})"
		super().__setitem__(key, value)

class NetMsgHandlerMetaClass(type):
	def __prepare__(name, bases):
		return Dict()

	def __new__(klass, name, bases, attributes):
		result = type.__new__(klass, name, bases, attributes)
		for k, v in attributes.items():
			if k.startswith("__"):
				continue
			NetMsgHandler.__msgid__[v.value] = getattr(result(), k)
		return result

class NetMsgHandler(metaclass=NetMsgHandlerMetaClass):
	__msgid__ = Dict()
	def __new__(klass, value=None):
		if klass is NetMsgHandler:
			return klass.__msgid__.get(value)
		if not hasattr(klass, "__instance__"):
			klass.__instance__ = super(NetMsgHandler, klass).__new__(klass)
		return klass.__instance__
