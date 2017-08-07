import struct

def readS32(rawData, offset):
	value = 0
	for i in range(5):
		byte = rawData[offset+i]
		value |= (byte & 0x7F) << (i * 7)
		if (byte & 0x80) == 0: break
	return value, i + 1

def writeS32(value):
	result = bytes()
	while 0x80 <= value:
		result += struct.pack("B", 0x80 | (value & 0xFF))
		value >>= 7
	result += struct.pack("B", value)
	return result

def readS24(rawData, offset):
	return sum(v << (i * 8) for i, v in enumerate(struct.unpack_from("2Bb", rawData, offset)))

def writeS24(value):
	return struct.pack("2Bb", value & 0xFF, value >> 8 & 0xFF, value >> 16)
