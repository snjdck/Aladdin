import lzma
import zlib
import struct
import sys
import os

def main(filePath):
	if not os.path.exists(filePath):
		return "file not exist."

	with open(filePath, "rb") as f:
		fileData = f.read()

	sign, version, dataSize = struct.unpack("3sBI", fileData[:8])

	print(sign, version, dataSize)

	if version < 13:
		version = 13

	if sign == b"CWS":
		rawData = zlib.decompress(fileData[8:])
	elif sign == b"FWS":
		rawData = fileData[8:]
	elif sign == b"ZWS":
		return "input file is already ZWS compressed."
	else:
		return "invalid swf file."
	
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