import lzma
import zlib
import struct
import math

def readUI16(rawData, offset):
	return struct.unpack_from("H", rawData, offset)[0]

def readUI32(rawData, offset):
	return struct.unpack_from("I", rawData, offset)[0]

def encodeLzmaSWF(lzmaData, dataSize, version):
	head = struct.pack("3sB2I", b"ZWS", version, dataSize, len(lzmaData)-13)
	return head + lzmaData[:5] + lzmaData[13:]

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