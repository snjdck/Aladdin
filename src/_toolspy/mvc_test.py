import unittest

from mvc import *

class A(Module):
	def onStartup(self):
		print("a startup")

class B(Module):
	def onStartup(self):
		print("b startup")


def newApp():
	app = Application()
	app.regModule(A())
	app.regModule(B())
	return app

class TestMVC(unittest.TestCase):
	def test(self):
		app = newApp()
		app.startup()


if __name__ == "__main__":
	unittest.main()