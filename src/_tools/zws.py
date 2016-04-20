import lzma
import zlib
import struct
import sys
import os

from swf import *

def findBestZlib(rawData):
	result = rawData
	for i in range(10):
		tempData = zlib.compress(rawData, i)
		print("zlib", i, len(tempData))
		if len(tempData) < len(result):
			result = tempData
	print(hex(len(result)), len(result))
	return result

def findBestLzma(rawData):
	result = rawData
	for i in range(10):
		tempData = lzma.compress(rawData, lzma.FORMAT_ALONE, -1, i)
		print("lzma", i, hex(tempData[3]), hex(tempData[4]), len(tempData))
		if len(tempData) < len(result):
			result = tempData
	print(hex(len(result)), len(result))
	return result

tagList = []

def removeTags(rawData, offset, tagType, tagHeadSize, tagBodySize):
	#remove ProductInfo, FrameLabel, ScriptLimits, Metadata
	if tagType in [41, 43, 65, 77]:
		return
	#hasMetadata = false
	if tagType == 69:
		tagBody = readUI32(rawData, offset+2)
		tagBody &= 0xEF
		tagList.append(rawData[offset:offset+2] + struct.pack("I", tagBody))
	else:
		tagSize = tagHeadSize + tagBodySize
		tagList.append(rawData[offset:offset+tagSize])

def main(filePath):
	if not os.path.exists(filePath):
		return "file not exist."

	with open(filePath, "rb") as f:
		fileData = f.read()

	sign, version, dataSize = decodeHead(fileData)

	if version < 13:
		version = 13

	rawData = decodeBody(fileData)

	if not rawData:
		return "invalid swf file."
	
	startOffset = visitTags(rawData, removeTags)
	rawData = rawData[:startOffset]
	for chunk in tagList:
		rawData += chunk

	dataSize = len(rawData) + 8

	lzmaData = findBestLzma(rawData)

	dotIndex = filePath.rfind(".")
	outputPath = filePath[:dotIndex] + "Compressed" + filePath[dotIndex:]
	
	with open(outputPath, "wb") as f:
		f.write(encodeLzmaSWF(lzmaData, dataSize, version))
	
	return "success."

if __name__ == "__main__":
	input(main(sys.argv[1]))