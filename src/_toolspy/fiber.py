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
	def __init__(self):
		self.fiberList = []

	def __call__(self, *args):
		result = [f() for f in args]
		self.fiberList += result
		return result

	def run(self):
		execFiberList(self.fiberList)
