import struct

class ByteArray:
	__slots__ = ("rawData", "endian")

	def __init__(self, endian="<"):
		self.rawData = bytes()
		self.endian = endian

	def writeU8(self, value):
		self.rawData += struct.pack("B", value)

	def writeS8(self, value):
		self.rawData += struct.pack("b", value)

	def writeU16(self, value, endian=None):
		if endian is None: endian = self.endian
		self.rawData += struct.pack(endian + "H", value)

	def writeS16(self, value, endian=None):
		if endian is None: endian = self.endian
		self.rawData += struct.pack(endian + "h", value)

	def writeU32(self, value, endian=None):
		if endian is None: endian = self.endian
		self.rawData += struct.pack(endian + "I", value)

	def writeS32(self, value, endian=None):
		if endian is None: endian = self.endian
		self.rawData += struct.pack(endian + "i", value)

	def writeU64(self, value, endian=None):
		if endian is None: endian = self.endian
		self.rawData += struct.pack(endian + "Q", value)

	def writeS64(self, value, endian=None):
		if endian is None: endian = self.endian
		self.rawData += struct.pack(endian + "q", value)

	def writeF16(self, value, endian=None):
		if endian is None: endian = self.endian
		self.rawData += struct.pack(endian + "e", value)

	def writeF32(self, value, endian=None):
		if endian is None: endian = self.endian
		self.rawData += struct.pack(endian + "f", value)

	def writeF64(self, value, endian=None):
		if endian is None: endian = self.endian
		self.rawData += struct.pack(endian + "d", value)

	_B = lambda f: lambda self, value: f(self, value, ">")
	_L = lambda f: lambda self, value: f(self, value, "<")

	writeU16BE = _B(writeU16)
	writeU16LE = _L(writeU16)

	writeS16BE = _B(writeS16)
	writeS16LE = _L(writeS16)

	writeU32BE = _B(writeU32)
	writeU32LE = _L(writeU32)

	writeS32BE = _B(writeS32)
	writeS32LE = _L(writeS32)

	writeU64BE = _B(writeU64)
	writeU64LE = _L(writeU64)

	writeS64BE = _B(writeS64)
	writeS64LE = _L(writeS64)

	writeF16BE = _B(writeF16)
	writeF16LE = _L(writeF16)

	writeF32BE = _B(writeF32)
	writeF32LE = _L(writeF32)

	writeF64BE = _B(writeF64)
	writeF64LE = _L(writeF64)

