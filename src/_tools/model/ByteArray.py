import struct

class ByteArrayW:
	__slots__ = ("rawData", "endian")

	def __init__(self, endian="<"):
		self.rawData = bytes()
		self.endian = endian

	def pack(self, fmt, value, endian=None):
		if endian is None: endian = self.endian
		self.rawData += struct.pack(endian + fmt, value)

	_W = lambda fmt: lambda self, value, endian=None: self.pack(fmt, value, endian)

	writeU8  = _W("B")
	writeS8  = _W("b")
	writeU16 = _W("H")
	writeS16 = _W("h")
	writeU32 = _W("I")
	writeS32 = _W("i")
	writeU64 = _W("Q")
	writeS64 = _W("q")
	writeF16 = _W("e")
	writeF32 = _W("f")
	writeF64 = _W("d")
	
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

class ByteArrayR:
	__slots__ = ("rawData", "endian", "position")

	def __init__(self, rawData=None, endian="<"):
		self.rawData = rawData
		self.endian = endian
		self.position = 0

	def unpack(self, fmt, endian=None):
		offset = self.position
		self.position += struct.calcsize(fmt)
		if endian is None: endian = self.endian
		return struct.unpack_from(endian + fmt, self.rawData, offset)[0]

	_R = lambda fmt: lambda self, endian=None: self.unpack(fmt, endian)

	readU8  = _R("B")
	readS8  = _R("b")
	readU16 = _R("H")
	readS16 = _R("h")
	readU32 = _R("I")
	readS32 = _R("i")
	readU64 = _R("Q")
	readS64 = _R("q")
	readF16 = _R("e")
	readF32 = _R("f")
	readF64 = _R("d")

	_B = lambda f: lambda self: f(self, ">")
	_L = lambda f: lambda self: f(self, "<")

	readU16BE = _B(readU16)
	readU16LE = _L(readU16)

	readS16BE = _B(readS16)
	readS16LE = _L(readS16)

	readU32BE = _B(readU32)
	readU32LE = _L(readU32)

	readS32BE = _B(readS32)
	readS32LE = _L(readS32)

	readU64BE = _B(readU64)
	readU64LE = _L(readU64)

	readS64BE = _B(readS64)
	readS64LE = _L(readS64)

	readF16BE = _B(readF16)
	readF16LE = _L(readF16)

	readF32BE = _B(readF32)
	readF32LE = _L(readF32)

	readF64BE = _B(readF64)
	readF64LE = _L(readF64)

if __name__ == "__main__":
	ba = ByteArrayW()
	ba.writeU8(2)
	ba.writeF32(9.3)
	print(ba.rawData)
	ba = ByteArrayR(ba.rawData)
	print(ba.readU8(), ba.readF32())
	input()