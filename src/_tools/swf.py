import lzma
import zlib
import struct
import math

def readUI16(rawData, offset):
	return struct.unpack_from("H", rawData, offset)[0]

def readUI32(rawData, offset):
	return struct.unpack_from("I", rawData, offset)[0]

def decodeHead(fileData):
	return struct.unpack_from("3sBI", fileData)

def decodeBody(fileData):
	sign, version, dataSize = decodeHead(fileData)
	if sign == b"CWS":
		return zlib.decompress(fileData[8:])
	if sign == b"FWS":
		return fileData[8:]
	if sign == b"ZWS":
		rawData = fileData[12:17] + struct.pack("2I",0xFFFFFFFF,0xFFFFFFFF) + fileData[17:]
		return lzma.decompress(rawData, lzma.FORMAT_ALONE)

def visitTags(rawData, handler):
	nBit = rawData[0] >> 3
	start = math.ceil((nBit*4+5) / 8.0) + 4
	rawDataSize = len(rawData)
	offset = start
	while offset < rawDataSize:
		flag = readUI16(rawData, offset)
		tagType = flag >> 6
		tagBodySize = flag & 0x3F
		if 0x3F == tagBodySize:
			tagBodySize = readUI32(rawData, offset+2)
			tagHeadSize = 6
		else:
			tagHeadSize = 2
		handler(rawData, offset, tagType, tagHeadSize, tagBodySize)
		offset += tagHeadSize + tagBodySize
	return start

def encodeSWF(rawData, version=0):
	if version < 9: version = 9
	head = struct.pack("3sBI", b"FWS", version, len(rawData)+8)
	return head + rawData

def encodeZlibSWF(rawData, version=0):
	if version < 9: version = 9
	head = struct.pack("3sBI", b"CWS", version, len(rawData)+8)
	return head + zlib.compress(rawData, 9)

def encodeLzmaSWF(rawData, version=0):
	if version < 13: version = 13
	body = lzma.compress(rawData, lzma.FORMAT_ALONE, -1, 9)
	head = struct.pack("3sB2I", b"ZWS", version, len(rawData)+8, len(body)-13)
	return head + body[:5] + body[13:]
