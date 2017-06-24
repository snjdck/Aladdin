import struct

def readS32(rawData, offset):
	value = count = 0
	while True:
		byte = rawData[offset + count]
		value |= (byte & 0x7F) << (count * 7)
		count += 1
		if (byte & 0x80) == 0 or count > 4:
			break
	return value, count


def writeS32(value):
	result = bytes()
	while True:
		if value < 0x80:
			result += struct.pack("B", value)
			break
		result += struct.pack("B", 0x80 | (value & 0xFF))
		value >>= 7
	return result


def readS24(rawData, offset):
	value = count = 0
	for byte in struct.unpack_from("2Bb", rawData, offset):
		value |= byte << (count * 8)
		count += 1
	return value


def writeS24(value):
	return struct.pack("2Bb", value & 0xFF, value >> 8 & 0xFF, value >> 16)

