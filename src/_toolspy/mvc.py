from ioc import *

__all__ = ("Application", "Module", "Msg", "Model", "Service", "Controller")

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
		self.handlerList = set()

	def notify(self, msgName, msgData=None):
		msg = Msg(msgName, msgData)
		for handler in self.handlerList:
			if msg.isProcessCanceled(): break
			handler.handleMsg(msg)
		return not msg.isDefaultPrevented()

	def regService(self, serviceInterface, serviceClass, asLocal):
		injector = self.injector if asLocal else self.injector.parent
		injector.mapSingleton(serviceInterface, serviceClass, realInjector=self.injector)

	def regModel(self, model, modelType=None):
		self.injector.mapValue(modelType or type(model), model)

	def delModel(self, modelType):
		self.injector.unmap(modelType)

	def regController(self, controller):
		self.regHandler(controller)

	def delController(self, controller):
		self.handlerList.remove(controller)

	def regHandler(self, handler):
		if handler in self.handlerList:
			return
		self.handlerList.add(handler)
		self.injector.injectInto(handler)

	def initAllModels(self): pass
	def initAllServices(self): pass
	def initAllControllers(self): pass
	def onStartup(self): pass

class Msg:
	__slots__ = ("name", "data", "defaultPreventedFlag", "processCanceledFlag")
	def __init__(self, name, data):
		self.name = name
		self.data = data
		self.defaultPreventedFlag = False
		self.processCanceledFlag = False

	def cancelProcess(self):
		self.processCanceledFlag = True

	def isProcessCanceled():
		return self.processCanceledFlag

	def preventDefault(self):
		self.defaultPreventedFlag = True

	def isDefaultPrevented():
		return self.defaultPreventedFlag

class Notifier:
	module: Inject(Module)
	def notify(self, msgName, msgData=None):
		return self.module.notify(msgName, msgData)

class Model(Notifier): pass
class Service(Notifier): pass

class Controller(Notifier):
	def __init__(self):
		self.handlerDict = {}

	def regHandler(self, msgName, handler):
		self.handlerDict[msgName] = handler

	def handleMsg(self, msg):
		handler = self.handlerDict.get(msg.name)
		if handler is None: return
		handler(msg)
