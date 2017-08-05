import sys

class Bound:
	def __init__(self):
		self.minX = sys.maxsize
		self.minY = sys.maxsize
		self.minZ = sys.maxsize
		self.maxX = -sys.maxsize
		self.maxY = -sys.maxsize
		self.maxZ = -sys.maxsize

	def add(self, x, y, z):
		if x < self.minX: self.minX = x
		if x > self.maxX: self.maxX = x
		if y < self.minY: self.minY = y
		if y > self.maxY: self.maxY = y
		if z < self.minZ: self.minZ = z
		if z > self.maxZ: self.maxZ = z