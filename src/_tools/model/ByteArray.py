import struct

def partialmethod(func, *args, **kwargs):
	def wrapper(self, *fargs, **fkwargs):
		nkwargs = kwargs.copy()
		nkwargs.update(fkwargs)
		return func(self, *args, *fargs, **nkwargs)
	return wrapper

class ByteArrayW:
	def __init__(self, endian="<"):
		self.endian = endian
		self.dirty = False
		self.pieces = []
		self.buffer = bytes()

	@property
	def rawData(self):
		if self.dirty:
			self.buffer += b"".join(self.pieces)
			self.pieces.clear()
			self.dirty = False
		return self.buffer

	def _add(self, value):
		self.pieces.append(value)
		self.dirty = True

	def pack(self, fmt, value, endian=None):
		fmt = (endian or self.endian) + fmt
		self._add(struct.pack(fmt, value))
		return self

	writeU8  = partialmethod(pack, "B")
	writeS8  = partialmethod(pack, "b")
	writeU16 = partialmethod(pack, "H")
	writeS16 = partialmethod(pack, "h")
	writeU32 = partialmethod(pack, "I")
	writeS32 = partialmethod(pack, "i")
	writeU64 = partialmethod(pack, "Q")
	writeS64 = partialmethod(pack, "q")
	writeF16 = partialmethod(pack, "e")
	writeF32 = partialmethod(pack, "f")
	writeF64 = partialmethod(pack, "d")

	def writeString(self, writer, value):
		value = value.encode()
		writer(self, len(value))
		self._add(value)
		return self

	writeString1 = partialmethod(writeString, writeU8 )
	writeString2 = partialmethod(writeString, writeU16)
	writeString4 = partialmethod(writeString, writeU32)

class ByteArrayR:
	__slots__ = ("rawData", "endian", "position")

	def __init__(self, rawData=None, endian="<"):
		self.rawData = rawData
		self.endian = endian
		self.position = 0

	def unpack(self, fmt, offset=None, endian=None):
		if offset is None:
			offset = self.position
			self.position += struct.calcsize(fmt)
		fmt = (endian or self.endian) + fmt
		return struct.unpack_from(fmt, self.rawData, offset)[0]

	readU8  = partialmethod(unpack, "B")
	readS8  = partialmethod(unpack, "b")
	readU16 = partialmethod(unpack, "H")
	readS16 = partialmethod(unpack, "h")
	readU32 = partialmethod(unpack, "I")
	readS32 = partialmethod(unpack, "i")
	readU64 = partialmethod(unpack, "Q")
	readS64 = partialmethod(unpack, "q")
	readF16 = partialmethod(unpack, "e")
	readF32 = partialmethod(unpack, "f")
	readF64 = partialmethod(unpack, "d")

	def readVector(self, length, offset=None, endian=None):
		if offset is None:
			return [self.readF32(None, endian) for _ in range(length)]
		return [self.readF32(offset + i * 4, endian) for i in range(length)]

	readVector4 = partialmethod(readVector, 4)
	readVector3 = partialmethod(readVector, 3)
	readVector2 = partialmethod(readVector, 2)

	def readFixString(self, length, charSet="gb2312", offset=None):
		start = self.position if offset is None else offset
		end = self.rawData.index(0, start, start + length)
		if offset is None: self.position += length
		return self.rawData[start:end].decode(charSet)
