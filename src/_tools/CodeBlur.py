from opcode import *
from avm2 import *
import avm2
from namegen import *


def optimize(tagBody):
	for begin, end, _ in parseABC(tagBody)[1]:
		parseInstruction(begin, end)

def parseInstruction(offset, end):
	while offset < end:
		opCode = _readUI8(offset)
		value, offset = _readInstruction(opCode, offset+1)
		if opCode == OP_pushstring:
			addStringToBlackSet(value)
	assert offset == end



import sys
import os
import re

from swf_tag import encodeTag, genImageTag
from swf import *
from SwfTagType import *

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
	tagType = SwfTagType(tagType)
	offset += tagHeadSize
	if tagType == SwfTagType.DoABC2:
		tagBody = rawData[offset:offset+tagBodySize]
		optimize(tagBody)
		infoList.append((offset, stringList.copy(), stringLocationList.copy(), namespaceList.copy()))
	if tagType == SwfTagType.SymbolClass:
		readSymbolClass(rawData, offset)

def readFile(path):
	if os.path.exists(path):
		with open(path) as f:
			return set(f.read().splitlines())
	return None

def writeFile(path, data):
	with open(path, "wb") as f:
		f.write(data)

keywords = readFile("keywords.txt")
excludeList = readFile("exclude.txt")

def isKeyword(name):
	if name in keywords:
		return True
	if ":" in name:
		for item in name.split(":"):
			if item not in keywords:
				return False
		return True
	return False

def main(filePath):
	if not os.path.exists(filePath):
		return "file not exist."

	with open(filePath, "rb") as f:
		fileData = f.read()

	sign, version, _ = decodeHead(fileData)

	rawData = decodeBody(fileData)

	if not rawData:
		return "invalid swf file."
	
	visitTags(rawData, removeTags)

	rawData = bytearray(rawData)

	totalStringSet = set()
	namespaceSet = set()
	for _offset, _stringList, _stringLocationList, _namespaceList in infoList:
		totalStringSet |= set(_stringList)
		namespaceSet |= set(_namespaceList)
	totalStringSet.remove(None)
	namespaceSet.remove(None)

	finalSet = whiteSet - blackSet - symbolSet - keywords - excludeList
	
	for name in namespaceSet - whiteSet - blackSet - symbolSet - keywords:
		if not name: continue
		if name.startswith(FilePrivateNS):
			if name[len(FilePrivateNS):] in finalSet:
				finalSet.add(name)
		else:
			m = AS_FILE.match(name)
			if m:
				if m.group(1) in finalSet:
					finalSet.add(name)
			elif not isKeyword(name):
				finalSet.add(name)
	
	remainSet = totalStringSet - whiteSet - blackSet - finalSet - symbolSet - keywords - excludeList
	for name in remainSet:
		if "/" in name or name.endswith(":anonymous"):
			finalSet.add(name)

	remainSet -= finalSet
	print([item for item in remainSet if not re.match(r"[$\w]+", item)])
	
	finaDict = mix(finalSet, totalStringSet | keywords)

	for _offset, _stringList, _stringLocationList, _namespaceList in infoList:
		for name in finaDict:
			if name not in _stringList:
				continue
			begin, end = _stringLocationList[_stringList.index(name)]
			rawData[_offset+begin:_offset+end] = finaDict[name]

	dotIndex = filePath.rfind(".")
	outputPath = filePath[:dotIndex] + "Mixed" + filePath[dotIndex:]
	
	writeFile(outputPath, encodeLzmaSWF(rawData, version))

	mixedNameList = "\r\n".join(item[0]+","+item[1].decode() for item in finaDict.items())
	notMixedNameList = "\r\n".join(name for name in totalStringSet - finalSet - blackSet - symbolSet - keywords)

	writeFile(filePath[:dotIndex] + "Mixed.csv", mixedNameList.encode())
	writeFile(filePath[:dotIndex] + "NotMixed.txt", notMixedNameList.encode())
	
	return "success."

if __name__ == "__main__":
	input(main(sys.argv[1]))