from fiber import *
import time

def test1():
	print(12)
	yield
	print(34)

def test2():
	print(56)
	yield
	print(78)

fiber = Fiber()
gr1, gr2 = fiber(test1, test2)
fiber.run()


fiber = Fiber()
@fiber
def ping():
	while True:
		print("ping")
		time.sleep(1)
		yield
@fiber
def pong():
	while True:
		print("pong")
		time.sleep(1)
		yield

fiber.run()

input()