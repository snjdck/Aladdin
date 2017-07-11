import sys
import os
from swf import *
from SwfTagType import *

SymbolClass = {}

def setSymbolData(symbolId, key, value):
	if symbolId not in SymbolClass:
		SymbolClass[symbolId] = {}
	symbolData = SymbolClass[symbolId]
	symbolData[key] = value

def readSymbolClass(rawData, offset):
	numSymbols = readUI16(rawData, offset)
	offset += 2
	for _ in range(numSymbols):
		symbolId = readUI16(rawData, offset)
		offset += 2
		end = offset
		while rawData[end] != 0:
			end += 1
		symbolName = rawData[offset:end].decode()
		index = symbolName.rfind("$")
		if index >= 0:
			symbolName = symbolName[:index]
		index = symbolName.rfind("_")
		if index >= 0:
			symbolName = symbolName[:index] + "." + symbolName[index+1:]
		setSymbolData(symbolId, "name", symbolName)
		offset = end + 1

def parseSWF(rawData, offset, tagType, tagHeadSize, tagBodySize):
	tagType = SwfTagType(tagType)
	offset += tagHeadSize
	if tagType == SwfTagType.SymbolClass:
		readSymbolClass(rawData, offset)
	elif tagType == SwfTagType.DefineBinaryData:
		symbolId = readUI16(rawData, offset)
		setSymbolData(symbolId, "data", rawData[offset+6:offset+tagBodySize])
	elif tagType == SwfTagType.DefineBitsJPEG2:
		symbolId = readUI16(rawData, offset)
		setSymbolData(symbolId, "data", rawData[offset+2:offset+tagBodySize])

def main(filePath):
	if not os.path.exists(filePath):
		return "file not exist."

	with open(filePath, "rb") as f:
		fileData = f.read()

	rawData = decodeBody(fileData)

	if not rawData:
		return "invalid swf file."
	
	visitTags(rawData, parseSWF)

	dirName = os.path.dirname(filePath)
	dirName = dirName + "/__export__" if len(dirName) > 0 else "__export__"

	if not os.path.exists(dirName):
		os.mkdir(dirName)

	for info in SymbolClass.values():
		if "data" not in info:
			continue
		with open(dirName + "/" + info["name"], "wb") as f:
			f.write(info["data"])
	
	return "success."

if __name__ == "__main__":
	input(main(sys.argv[1]))