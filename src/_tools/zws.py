import lzma
import zlib
import struct
import sys
import os
import math

def removeTags(rawData):
	nBit = rawData[0] >> 3
	offset = math.ceil((nBit*4+5) / 8.0) + 4
	result = rawData[:offset]
	rawDataSize = len(rawData)
	while offset < rawDataSize:
		flag = struct.unpack("H", rawData[offset:offset+2])[0]
		tagType = flag >> 6
		tagBodySize = flag & 0x3F
		if 0x3F == tagBodySize:
			tagBodySize = struct.unpack("I", rawData[offset+2:offset+6])[0]
			tagSize = tagBodySize + 6
		else:
			tagSize = tagBodySize + 2
		#remove Metadata and ProductInfo
		if not (tagType == 41 or tagType == 77):
			#hasMetadata = false
			if tagType == 69:
				tagBody = struct.unpack("I", rawData[offset+2:offset+6])[0]
				tagBody &= 0xEF
				result += rawData[offset:offset+2] + struct.pack("I", tagBody)
			else:
				result += rawData[offset:offset+tagSize]
		offset += tagSize
	return result

def main(filePath):
	if not os.path.exists(filePath):
		return "file not exist."

	with open(filePath, "rb") as f:
		fileData = f.read()

	sign, version, dataSize = struct.unpack("3sBI", fileData[:8])

	if version < 13:
		version = 13

	if sign == b"CWS":
		rawData = zlib.decompress(fileData[8:])
	elif sign == b"FWS":
		rawData = fileData[8:]
	elif sign == b"ZWS":
		rawData = fileData[12:17] + struct.pack("2I",0xFFFFFFFF,0xFFFFFFFF) + fileData[17:]
		rawData = lzma.decompress(rawData, lzma.FORMAT_ALONE)
	else:
		return "invalid swf file."
	
	rawData = removeTags(rawData)
	dataSize = len(rawData) + 8
	
	lzmaData = lzma.compress(rawData, lzma.FORMAT_ALONE, -1, 7)
	lzmaSize = len(lzmaData) - 13

	dotIndex = filePath.rfind(".")
	outputPath = filePath[:dotIndex] + "Compressed" + filePath[dotIndex:]
	
	with open(outputPath, "wb") as f:
		f.write(struct.pack("3sB2I", b"ZWS", version, dataSize, lzmaSize))
		f.write(lzmaData[:5])
		f.write(lzmaData[13:])
	
	return "success."

if __name__ == "__main__":
	input(main(sys.argv[1]))