import struct
import avm
from opcode import *

writeS24 = avm.writeS24
writeS32 = avm.writeS32

rawData = None
offset = 0

stringList = [None]
namespaceList = [None]
namespaceSetList = [None]
multinameList = [None]

whiteSet = set() #Trait, ParamName, MethodName, protectedNS, instructionHasName
blackSet = set() #Metadata, defaultValue, pushString

def skipCString():
	global offset
	while rawData[offset] != 0:
		offset += 1
	offset += 1

def skipNumber():
	global offset
	offset += 8

def readString():
	global offset
	size = readS32()
	begin = offset
	offset += size
	stringList.append(rawData[begin:offset].decode())

def readNamespace():
	readUI8()
	index = readS32()
	namespaceList.append(stringList[index])

def readNamespaceSet():
	namespaceSetList.append(readS32List(lambda:namespaceList[readS32()]))

def _readUI8(offset):
	return rawData[offset]

def _readS24(offset):
	return avm.readS24(rawData, offset)

def _readS32(offset):
	return avm.readS32(rawData, offset)

def readUI8():
	global offset
	value = _readUI8(offset)
	offset += 1
	return value

def readS24():
	global offset
	value = _readS24(offset)
	offset += 3
	return value

def readS32():
	global offset
	value, count = _readS32(offset)
	offset += count
	return value

def readMultiName():
	flag = readUI8()
	if flag in [7, 13]:
		multinameList.append((flag, namespaceList[readS32()], stringList[readS32()]))
	elif flag in [9, 14]:
		multinameList.append((flag, stringList[readS32()], namespaceSetList[readS32()]))
	elif flag in [15, 16]:
		multinameList.append((flag, stringList[readS32()]))
	elif flag in [27, 28]:
		multinameList.append((flag, namespaceSetList[readS32()]))
	elif flag == 29:
		multinameList.append((flag, stringList[readS32()], readS32List()))
	elif flag in [17, 18]:
		multinameList.append((flag, None))
	else: assert False, flag


def readParamName():
	whiteSet.add(stringList[readS32()])

def readDefaultParam(valueIndex):
	valueType = readUI8()
	if valueType == 1:
		blackSet.add(stringList[valueIndex])
	elif valueType == 8:
		blackSet.add(namespaceList[valueIndex])

def readMethodInfo():
	param_count = readS32()
	readS32()
	readS32List(count=param_count)
	nameIndex = readS32()
	if nameIndex: whiteSet.add(stringList[nameIndex])
	flag = readUI8()
	if flag & 0x08: readS32List(lambda:readDefaultParam(readS32()))
	if flag & 0x80: readS32List(readParamName, param_count)

def readInstanceInfo():
	readS32()
	readS32()
	if readUI8() & 0x08:
		whiteSet.add(namespaceList[readS32()])
	readS32List()
	readMethodIndexAndTrait()

def readMethodBody():
	global offset
	readS32List(count=5)
	codeLen = readS32()
	begin = offset
	offset += codeLen
	readS32List(lambda:readS32List(count=5))
	readS32List(readTrait)
	return begin, begin + codeLen

def readMetadataKV():
	blackSet.add(stringList[readS32()])
	blackSet.add(stringList[readS32()])

def readMetadata():
	blackSet.add(stringList[readS32()])
	readS32List(readMetadataKV)

def readTrait():
	addMultinameToWhiteSet(readS32())
	flag = readUI8()
	readS32()
	readS32()
	if (flag & 0xF) in (0, 6):
		valueIndex = readS32()
		if valueIndex: readDefaultParam(valueIndex)
	if flag & 0x40: readS32List()

def addMultinameToWhiteSet(index):
	if index == 0: return
	multiname = multinameList[index]
	flag = multiname[0]

	if flag in [7, 13]:
		whiteSet.add(multiname[1])
		whiteSet.add(multiname[2])
	elif flag in [9, 14]:
		whiteSet.add(multiname[1])
		for name in multiname[2]: whiteSet.add(name)
	elif flag in [15, 16]:
		whiteSet.add(multiname[1])
	elif flag in [27, 28]:
		for name in multiname[1]: whiteSet.add(name)
	elif flag == 29:
		whiteSet.add(multiname[1])
		for nameIndex in multiname[2]: addMultinameToWhiteSet(nameIndex)
	else: assert False, multiname

def readMethodIndexAndTrait(): readS32(); readS32List(readTrait)
def readConstant(reader=None): readS32List(reader, readS32()-1)
def readS32List(reader=None, count=None):
	if count  == None: count = readS32()
	if reader == None: reader = readS32
	if hasattr(reader, "__call__"):
		return [reader() for _ in range(count)]
	return [[func() for func in reader] for _ in range(count)]


def parseABC(tagBody):
	global rawData, offset
	global stringList
	global namespaceList
	global namespaceSetList
	global multinameList

	stringList = [None]
	namespaceList = [None]
	namespaceSetList = [None]
	multinameList = [None]

	rawData = tagBody
	offset = 4
	skipCString()
	offset += 4
	readConstant()
	readConstant()
	readConstant(skipNumber)
	readConstant(readString)
	readConstant(readNamespace)
	readConstant(readNamespaceSet)
	readConstant(readMultiName)
	readS32List(readMethodInfo)
	readS32List(readMetadata)
	classCount = readS32()
	readS32List(readInstanceInfo, classCount)
	readS32List(readMethodIndexAndTrait, classCount)
	readS32List(readMethodIndexAndTrait)
	methodBodyList = readS32List(readMethodBody)
	assert len(rawData) == offset
	return methodBodyList

def optimize(tagBody):
	methodBodyList = parseABC(tagBody)
	global rawData
	rawData = bytearray(tagBody)
	for begin, end in methodBodyList:
		parseInstruction(begin, end)
	return rawData

def _readInstruction(opCode, offset):
	value = None
	if opCode in singleU32Imm:
		value, count = _readS32(offset)
		offset += count
	elif opCode in doubleU32Imm:
		value, count = _readS32(offset)
		offset += count
		_, count = _readS32(offset)
		offset += count
	elif opCode in singleS24Imm:
		value = _readS24(offset)
		offset += 3
	elif opCode in singleByteImm:
		_readUI8(offset)
		offset += 1
	elif opCode == OP_debug:
		_readUI8(offset)
		offset += 1
		_, count = _readS32(offset)
		offset += count
		_readUI8(offset)
		offset += 1
		_, count  = _readS32(offset)
		offset += count
	elif opCode == OP_lookupswitch:
		value = [_readS24(offset)]
		offset += 3
		caseCount, count = _readS32(offset)
		offset += count
		for _ in range(caseCount+1):
			value.append(_readS24(offset))
			offset += 3
	return value, offset


def parseInstruction(offset, end):
	while offset < end:
		opCode = _readUI8(offset)
		value, offset = _readInstruction(opCode, offset+1)

		if opCode == OP_pushstring:
			blackSet.add(stringList[value])
		elif opCode in hasNameImm:
			addMultinameToWhiteSet(value)

	assert offset == end



import struct
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
		#print(whiteSet - blackSet - symbolSet - keywords)

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