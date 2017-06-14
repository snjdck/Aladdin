import struct


def isImage(data):
	return isPNG(data) or isJPG(data) or isGIF(data)

def optimizeImage(data):
	if isPNG(data):
		return optimizePNG(data)
	if isJPG(data):
		return optimizeJPG(data)
	if isGIF(data):
		return optimizeGIF(data)
	return data


def isPNG(data):
	if len(data) < 8:
		return False
	return data[:8] == b"\x89PNG\x0d\x0a\x1a\x0a"

def isJPG(data):
	if len(data) < 4:
		return False
	return data[:2] == b"\xff\xd8" and data[-2:] == b"\xff\xd9"

def isGIF(data):
	if len(data) < 6:
		return False
	return data[:6] == b"GIF89a"

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

def optimizeJPG(data):
	begin = end = 2
	while end < len(data):
		head = struct.unpack_from(">H", data, end)[0]
		if head & 0xFFE0 != 0xFFE0:
			break
		size = struct.unpack_from(">2H", data, end)[1] + 2
		if head == 0xFFE0:
			begin += size
		end += size
	return data[:begin] + data[end:]

def optimizeGIF(data):
	return data
