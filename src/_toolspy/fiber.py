__all__ = ["Fiber"]

def nextValue(array, value):
	return array[(array.index(value) + 1) % len(array)]

def execFiberList(fiberList):
	if len(fiberList) <= 0:
		return
	fiber = fiberList[0]
	while True:
		try:
			value = next(fiber)
		except StopIteration:
			if len(fiberList) == 1:
				fiberList.clear()
				break
			value = nextValue(fiberList, fiber)
			fiberList.remove(fiber)
			fiber = value
		else:
			fiber = nextValue(fiberList, fiber) if value is None else value

class Fiber:
	fiberList = []

	@classmethod
	def run(klass):
		execFiberList(klass.fiberList)

	def __new__(klass, func):
		value = func()
		klass.fiberList.append(value)
		return value

if __name__ == "__main__":
	def test1():
		print(12)
		yield
		print(34)

	def test2():
		print(56)
		yield
		print(78)

	gr1 = Fiber(test1)
	gr2 = Fiber(test2)

	Fiber.run()
	input()