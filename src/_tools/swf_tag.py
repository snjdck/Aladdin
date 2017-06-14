import struct
from image import optimizeImage


def encodeTag(tagType, tagBody):
	tagBodySize = len(tagBody)
	if tagBodySize < 0x3F:
		tagHead = struct.pack("<H" , (tagType << 6) | tagBodySize)
	else:
		tagHead = struct.pack("<HI", (tagType << 6) | 0x3F, tagBodySize)
	return tagHead + tagBody



def genSymbolClassTag(symbol_list):
	tagBody = struct.pack("<H", len(symbol_list))
	for i in range(len(symbol_list)):
		tagBody += struct.pack("<H", i+1) + symbol_list[i].encode() + b"\x00"
	return encodeTag(76, tagBody)



def genBinaryTag(id, data):
	tagBody = struct.pack("<HI", id, 0) + data
	return encodeTag(87, tagBody)



def genImageTag(id, data):
	tagBody = struct.pack("<H", id) + optimizeImage(data)
	return encodeTag(21, tagBody)
