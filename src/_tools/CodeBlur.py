
from opcode import *
from avm2 import *
import avm2
from namegen import *


def optimize(tagBody):
	for begin, end, _ in parseABC(tagBody):
		parseInstruction(begin, end)

def parseInstruction(offset, end):
	while offset < end:
		opCode = _readUI8(offset)
		value, offset = _readInstruction(opCode, offset+1)
		if opCode == OP_pushstring:
			addStringToBlackSet(value)
		elif opCode in hasNameImm:
			addMultinameToWhiteSet(value, True)
	assert offset == end



import sys
import os

from swf_tag import encodeTag, genImageTag
from swf import *

symbolSet = set()
infoList = []

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
		symbolSet.add(symbolName)
		offset = end + 1

def removeTags(rawData, offset, tagType, tagHeadSize, tagBodySize):
	offset += tagHeadSize
	if tagType == 82:
		tagBody = rawData[offset:offset+tagBodySize]
		optimize(tagBody)
		infoList.append((offset, stringList.copy(), stringLocationList.copy()))
	if tagType == 76:
		readSymbolClass(rawData, offset)

def readFile(path):
	if os.path.exists(path):
		with open(path) as f:
			return set(f.read().splitlines())
	return None

def writeFile(path, data):
	with open(path, "wb") as f:
		f.write(data)

def main(filePath):
	if not os.path.exists(filePath):
		return "file not exist."

	with open(filePath, "rb") as f:
		fileData = f.read()

	sign, version, _ = decodeHead(fileData)

	rawData = decodeBody(fileData)

	if not rawData:
		return "invalid swf file."
	
	keywords = readFile("keywords.txt")
	excludeList = readFile("exclude.txt")

	visitTags(rawData, removeTags)

	rawData = bytearray(rawData)

	totalStringSet = keywords.copy()
	for _offset, _stringList, _stringLocationList in infoList:
		totalStringSet |= set(_stringList)

	finalSet = whiteSet - blackSet - symbolSet - keywords - excludeList
	finaDict = mix(finalSet, totalStringSet.copy())
	
	for _offset, _stringList, _stringLocationList in infoList:
		for name in finaDict:
			if name not in _stringList:
				continue
			begin, end = _stringLocationList[_stringList.index(name)]
			rawData[_offset+begin:_offset+end] = finaDict[name]

	dotIndex = filePath.rfind(".")
	outputPath = filePath[:dotIndex] + "Mixed" + filePath[dotIndex:]
	
	writeFile(outputPath, encodeLzmaSWF(rawData, version))

	mixedNameList = "\r\n".join(item[0]+","+item[1].decode() for item in finaDict.items())
	notMixedNameList = "\r\n".join(name for name in totalStringSet - whiteSet - blackSet - symbolSet - keywords if name)

	writeFile(filePath[:dotIndex] + "Mixed.csv", mixedNameList.encode())
	writeFile(filePath[:dotIndex] + "NotMixed.txt", notMixedNameList.encode())
	
	return "success."

if __name__ == "__main__":
	input(main(sys.argv[1]))