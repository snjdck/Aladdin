import unittest

from mvc import *

class TestMsgName(MsgName):
	test = 0

class TestController(Controller):
	model1: Inject("Model1")
	
	@MsgHandler(TestMsgName.test)
	def onTest(self, msg):
		print("onEvent", msg.name, self.model1)



class A(Module):

	def initAllModels(self):
		self.regModel(Model1())

	def initAllControllers(self):
		self.regController(TestController())

	def onStartup(self):
		print("a startup")
		self.notify(TestMsgName.test)

class B(Module):
	def initAllModels(self):
		self.regModel(Model2())

	def onStartup(self):
		print("b startup")
		

class Model1:
	def __init__(self):
		self.data = 100

class Model2:
	def __init__(self):
		self.data = "200"

def newApp():
	app = Application()
	app.regModule(A())
	app.regModule(B())
	return app


app = newApp()
app.startup()

input()

