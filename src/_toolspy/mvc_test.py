import unittest

from mvc import *

class TestMsgName(MsgName):
	test = 0

class TestController(Controller):
	model1: Inject("Model1")
	service1: Inject("Service1")
	service2: Inject("Service2")

	def __inject__(self):
		self.service1.done += self.onDone

	def onDone(self):
		print("done")
	
	@MsgHandler(TestMsgName.test)
	def onTest(self, msg):
		print("onEvent", msg.name, self.model1)
		self.service1.dosomething()
		self.service2.fuck()



class A(Module):

	def initAllModels(self):
		self.regModel(Model1())

	def initAllServices(self):
		self.regService(Service1, Service1, True)

	def initAllControllers(self):
		self.regController(TestController)

	def onStartup(self):
		print("a startup")
		self.notify(TestMsgName.test)

class B(Module):
	def initAllModels(self):
		self.regModel(Model2())

	def initAllServices(self):
		self.regService(Service2, Service2)

	def onStartup(self):
		print("b startup")
		

class Model1:
	def __init__(self):
		self.data = 100

class Model2:
	def __init__(self):
		self.data = "200"

class Service1(Service):
	def __init__(self):
		self.done = Signal()
	def dosomething(self):
		print("dosomething")
		self.done()

class Service2(Service):
	def fuck(self):
		print("fuck")

def newApp():
	app = Application()
	app.regModule(A())
	app.regModule(B())
	return app


app = newApp()
app.startup()

input()

