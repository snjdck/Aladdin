
from opcode import *
from avm2 import *
import avm2


def optimize(tagBody):
	methodBodyList = parseABC(tagBody)
	for begin, end, _ in methodBodyList:
		parseInstruction(begin, end)




def parseInstruction(offset, end):
	while offset < end:
		opCode = _readUI8(offset)
		value, offset = _readInstruction(opCode, offset+1)

		if opCode == OP_pushstring:
			addStringToBlackSet(value)
		elif opCode in hasNameImm:
			addMultinameToWhiteSet(value)

	assert offset == end



import sys
import os

from swf_tag import encodeTag, genImageTag
from swf import *

symbolSet = set()
keywords = None
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
		infoList.append((offset, stringLocationList.copy()))
	if tagType == 76:
		readSymbolClass(rawData, offset)

def main(filePath):
	if not os.path.exists(filePath):
		return "file not exist."

	with open(filePath, "rb") as f:
		fileData = f.read()

	sign, version, _ = decodeHead(fileData)

	rawData = decodeBody(fileData)

	if not rawData:
		return "invalid swf file."
	
	global keywords
	with open("keywords.txt", "r") as f:
		keywords = set(f.read().splitlines())

	offset = visitTags(rawData, removeTags)

	rawData = bytearray(rawData)

	print(set(stringList) - whiteSet - blackSet - symbolSet - keywords)
	namespaceSet = set(namespaceList)
	finalSet = whiteSet - blackSet - symbolSet - keywords
	finaDict = {}
	mixSet = finalSet.copy()
	mixDict = {}
	for namespace in finalSet & namespaceSet:
		if ":" in namespace:
			mixSet.remove(namespace)
	
	for item in mixSet:
		t = list(item)
		t.reverse()
		mixDict[item] = "".join(t)

	for name in finalSet:
		finaDict[name] = mixDict[name] if name in mixDict else ":".join(mixDict.get(item, item) for item in name.split(":"))

	for name in finaDict:
		index = stringList.index(name)
		begin, end = stringLocationList[index]
		print(rawData[begin:end])
		#assert rawData[begin:end].decode() == name

	dotIndex = filePath.rfind(".")
	outputPath = filePath[:dotIndex] + "Mixed" + filePath[dotIndex:]
	
	with open(outputPath, "wb") as f:
		f.write(encodeLzmaSWF(rawData, version))
	
	return "success."

if __name__ == "__main__":
	input(main(sys.argv[1]))