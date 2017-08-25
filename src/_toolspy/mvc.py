from signal import *
from ioc import *

__all__ = ("Application", "Module", "Model", "Service", "Controller", "MsgName", "MsgHandler") + ("Inject", "Signal")

class Application:
	def __init__(self):
		self.injector = Injector()
		self.injector.mapValue(Application, self, realInjector=None)
		self.injector.mapValue(Injector, self.injector, realInjector=None)
		self.moduleDict = {}

	def regModule(self, module):
		assert type(module) not in self.moduleDict
		self.moduleDict[type(module)] = module
		module.injector.parent = self.injector

	def startup(self):
		moduleList = self.moduleDict.values()
		for module in moduleList: module.initAllModels()
		for module in moduleList: module.initAllServices()
		for module in moduleList: module.initAllControllers()
		for module in moduleList: module.onStartup()

class Module:
	def __init__(self):
		self.injector = Injector()
		self.injector.mapValue(Module, self, realInjector=None)
		self.injector.mapValue(Injector, self.injector, realInjector=None)
		self.controllerDict = {}

	def notify(self, msgName, msgData=None):
		msg = Msg(msgName, msgData)
		for handler in self.controllerDict.values():
			if msg.isProcessCanceled(): break
			handler.handleMsg(msg)
		return not msg.isDefaultPrevented()

	def regService(self, serviceInterface, serviceClass, asLocal=False):
		injector = self.injector if asLocal else self.injector.parent
		injector.mapSingleton(serviceInterface, serviceClass, realInjector=self.injector)

	def regModel(self, model, modelType=None):
		self.injector.mapValue(modelType or type(model), self.injector(model), realInjector=None)

	def delModel(self, modelType):
		self.injector.unmap(modelType)

	def regController(self, controllerType):
		assert controllerType not in self.controllerDict
		controller = self.injector(controllerType())
		self.controllerDict[controllerType] = controller

	def delController(self, controllerType):
		del self.controllerDict[controllerType]

	def initAllModels(self): pass
	def initAllServices(self): pass
	def initAllControllers(self): pass
	def onStartup(self): pass

class Notifier:
	module: Inject(Module)
	def notify(self, msgName, msgData=None):
		return self.module.notify(msgName, msgData)

class Model(Notifier): pass
class Service(Notifier): pass

class MsgHandler:
	__slots__ = ("name", "handler")
	def __init__(self, name):
		self.name = name

	def __call__(self, handler):
		self.handler = handler
		return self

class ControllerMetaClass(type):
	def __new__(cls, name, bases, attributes):
		handlerDict = {v.name: v.handler for v in attributes.values() if isinstance(v, MsgHandler)}
		attributes = {k: v for k, v in attributes.items() if not isinstance(v, MsgHandler)}
		result = type.__new__(cls, name, bases, attributes)
		result.__handler__ = handlerDict
		return result

class Controller(Notifier, metaclass=ControllerMetaClass):
	def handleMsg(self, msg):
		handler = self.__handler__.get(msg.name)
		if handler is None: return
		handler(self, msg)

class Msg:
	__slots__ = ("name", "data", "defaultPreventedFlag", "processCanceledFlag")
	def __init__(self, name, data):
		self.name = name
		self.data = data
		self.defaultPreventedFlag = False
		self.processCanceledFlag = False

	def cancelProcess(self):
		self.processCanceledFlag = True

	def isProcessCanceled(self):
		return self.processCanceledFlag

	def preventDefault(self):
		self.defaultPreventedFlag = True

	def isDefaultPrevented(self):
		return self.defaultPreventedFlag

class MsgNameMetaClass(type):
	def __new__(cls, name, bases, attributes):
		for key in attributes:
			if not key.startswith("__"):
				attributes[key] = f"{name}.{key}"
		return type.__new__(cls, name, bases, attributes)

class MsgName(metaclass=MsgNameMetaClass):
	pass
