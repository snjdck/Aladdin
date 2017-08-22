from signal import *

def a():
	print("a called")

def b():
	print("b called")

signal = Signal()

signal += a
signal += a
signal += b
signal += b

signal()
signal()

print(a in signal)

input()