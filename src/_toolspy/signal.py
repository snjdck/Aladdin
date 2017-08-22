
class Signal:
	def __init__(self, *argTypes):
		self.argTypes = argTypes
		self.handlerDict = {}

	def add(self, handler, once=False):
		self.handlerDict[handler] = once

	def remove(self, handler):
		del self.handlerDict[handler]

	def __contains__(self, handler):
		return handler in self.handlerDict

	def __call__(self, *args, **kwargs):
		assert len(args) == len(self.argTypes)
		assert all(isinstance(a, b) for a, b in zip(args, self.argTypes) if a is not None)
		for handler, once in list(self.handlerDict.items()):
			handler(*args, **kwargs)
			if once: self.remove(handler)

	def __iadd__(self, handler):
		self.add(handler)
		return self

	def __isub__(self, handler):
		self.remove(handler)
		return self
