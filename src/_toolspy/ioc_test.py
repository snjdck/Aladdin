import unittest
from ioc import *

class A:
	a1: Inject("A")
	a2: Inject("A", "2")
	b1: Inject("B")
	b2: Inject("B", "b2")

class B:
	a1: Inject(A)
	a2: Inject(A, "2")
	b1: Inject("B")
	b2: Inject("B", "b2")

class TestInjector(unittest.TestCase):

	def test_calcKey(self):
		self.assertEqual(Injector.calcKey(A), "A")
		self.assertEqual(Injector.calcKey(A, None), "A")
		self.assertEqual(Injector.calcKey(A, ""), "A")
		self.assertEqual(Injector.calcKey(A, "1"), "A@1")

		self.assertEqual(Injector.calcKey("A"), "A")
		self.assertEqual(Injector.calcKey("A", None), "A")
		self.assertEqual(Injector.calcKey("A", ""), "A")
		self.assertEqual(Injector.calcKey("A", "1"), "A@1")

		self.assertEqual(Injector.calcKey(A, isMeta=True), "A@")
		self.assertEqual(Injector.calcKey("A", None, isMeta=True), "A@")
		self.assertEqual(Injector.calcKey("A", "", isMeta=True), "A@")
		self.assertEqual(Injector.calcKey("A", "1", isMeta=True), "A@")

	def test_getRule(self):
		parent = Injector()
		injector = Injector(parent)

		a1, a2 = A(), A()

		parent.mapValue(A, a1)

		self.assertIs(injector.getRule("A", False), None)
		self.assertIs(injector.getRule("A"), parent.getRule("A"))

		injector.mapValue(A, a2)

		self.assertIsNot(injector.getRule("A", False), None)
		self.assertIsNot(injector.getRule("A"), None)
		self.assertIsNot(injector.getRule("A"), parent.getRule("A"))

	def test_call(self):
		injector = Injector()
		a = A()
		self.assertIs(injector(a), a)

	def test_rshift(self):
		injector = Injector()
		a = A()
		b = B()
		self.assertIs(injector >> a >> b, injector)

	def test_getitem(self):
		a1, a2 = A(), A()
		b1, b2 = B(), B()
		injector = Injector()
		injector.mapValue(A, a1)
		injector.mapValue(B, b1)
		injector.mapValue(A, a2, "2")
		injector.mapValue(B, b2, "b2")

		self.assertIs(injector[A], a1)
		self.assertIs(injector[A:"2"], a2)
		self.assertIs(injector[A, B][0], a1)
		self.assertIs(injector[A, B][1], b1)

		injector >> a1 >> a2 >> b1 >> b2

		for item in [a1, a2, b1, b2]:
			self.assertIs(item.a1, a1)
			self.assertIs(item.a2, a2)
			self.assertIs(item.b1, b1)
			self.assertIs(item.b2, b2)

	def test_injectInto(self):
		injector = Injector()
		injector.mapSingleton(A)
		injector.mapSingleton(B)

		self.assertIs(injector[A].b1, injector[B].b1)


if __name__ == "__main__":
	unittest.main()
