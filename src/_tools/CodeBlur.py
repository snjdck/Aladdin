
from opcode import *
from avm2 import *
import avm2


def optimize(tagBody):
	methodBodyList = parseABC(tagBody)
	rawData = bytearray(tagBody)
	for begin, end, _ in methodBodyList:
		parseInstruction(begin, end)
	return rawData




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

tagList = []
symbolSet = set()
keywords = None

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
		tagList.append(encodeTag(tagType, optimize(tagBody)))
		return
	if tagType == 76:
		readSymbolClass(rawData, offset)
	if tagType == 0:
		print(len(whiteSet), len(blackSet), len(whiteSet - blackSet))
		print(len(whiteSet - blackSet - symbolSet - keywords))
		print(set(stringList) - whiteSet - blackSet - symbolSet - keywords)
		newSet = whiteSet - blackSet - symbolSet - keywords
		namespaceSet = set(namespaceList)
		print(namespaceSet - whiteSet)
		def testFuck(name):
			if name != "FilePrivateNS" and name not in whiteSet and name not in keywords:
				print(name)
		for namespace in whiteSet & namespaceSet:
			index = namespace.rfind(":")
			if index < 0:
				testFuck(namespace)
			else:
				testFuck(namespace[:index])
				testFuck(namespace[index+1:])

	tagList.append(rawData[offset-tagHeadSize:offset+tagBodySize])

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
	rawData = rawData[:offset]
	for chunk in tagList:
		rawData += chunk

	dotIndex = filePath.rfind(".")
	outputPath = filePath[:dotIndex] + "Mixed" + filePath[dotIndex:]
	
	with open(outputPath, "wb") as f:
		f.write(encodeLzmaSWF(rawData, version))
	
	return "success."

if __name__ == "__main__":
	input(main(sys.argv[1]))