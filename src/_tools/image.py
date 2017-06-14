import struct



def optimizeImage(data):
	if isPNG(data):
		return optimizePNG(data)
	return data


def isPNG(data):
	return data[:8] == b"\x89\x50\x4e\x47\x0d\x0a\x1a\x0a"


def optimizePNG(data):
	offset = 8
	result = data[:offset]
	while offset < len(data):
		head = data[offset+4:offset+8].decode()
		size = struct.unpack_from(">I", data, offset)[0]
		tail = offset + size + 12
		if not (head == "tEXt" or head == "zTXt" or head == "iTXt" or head == "tIME"):
			result += data[offset:tail]
		offset = tail
	return result
