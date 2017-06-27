from opcode import *
import avm

__all__ = (
	"stringLocationList",
	"stringList",
	"namespaceList",
	"whiteSet",
	"blackSet",
	"writeS24",
	"writeS32",
	"_readUI8",
	"_readS24",
	"_readS32",
	"parseABC",
	"_readInstruction",
	"addMultinameToWhiteSet",
	"addStringToBlackSet"
)

writeS24 = avm.writeS24
writeS32 = avm.writeS32

stringLocationList = [None]
stringList = [None]
namespaceList = [None]
namespaceSetList = [None]
multinameList = [None]

whiteSet = set() #Trait, ParamName, MethodName, protectedNS, instructionHasName
blackSet = set() #Metadata, defaultValue, pushString

rawData = None
offset = 0

def skipCString():
	global offset
	while rawData[offset] != 0:
		offset += 1
	offset += 1

def skipString():
	global offset
	offset = readS32() + offset

def skipNumber():
	global offset
	offset += 8

def readString():
	global offset
	size = readS32()
	begin = offset
	offset += size
	stringLocationList.append((begin, offset))
	stringList.append(rawData[begin:offset].decode())

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

def readConstant(reader=None):
	readS32List(reader, readS32()-1)

def readS32List(reader=None, count=None):
	if count  == None and isinstance(reader, int):
		reader, count = count, reader
	if count  == None: count = readS32()
	if reader == None: reader = readS32
	if hasattr(reader, "__call__"):
		return [reader() for _ in range(count)]
	return [[func() for func in reader] for _ in range(count)]

def readNamespace():
	readUI8()
	namespaceList.append(stringList[readS32()])

def readNamespaceSet():
	namespaceSetList.append(readS32List(lambda:namespaceList[readS32()]))

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

def readMethodInfo():
	param_count = readS32()
	readS32()
	readS32List(param_count)
	nameIndex = readS32()
	if nameIndex: whiteSet.add(stringList[nameIndex])
	flag = readUI8()
	if flag & 0x08: readS32List(lambda:readDefaultParam(readS32()))
	if flag & 0x80: readS32List(readParamName, param_count)

def readDefaultParam(valueIndex):
	valueType = readUI8()
	if valueType == 1:
		blackSet.add(stringList[valueIndex])
	elif valueType == 8:
		blackSet.add(namespaceList[valueIndex])

def readParamName():
	whiteSet.add(stringList[readS32()])

def readMetadata():
	addStringToBlackSet(readS32())
	readS32List(readMetadataKV)

def readMetadataKV():
	addStringToBlackSet(readS32())
	addStringToBlackSet(readS32())

def readInstanceInfo():
	readS32List(2)
	if readUI8() & 0x08:
		whiteSet.add(namespaceList[readS32()])
	readS32List()
	readMethodIndexAndTrait()

def readMethodIndexAndTrait():
	readS32()
	readS32List(readTrait)

def readMethodBody():
	global offset
	readS32List(5)
	codeLen = readS32()
	begin = offset
	offset += codeLen
	exceptionList = readS32List(lambda:readS32List(5)[2])
	readS32List(readTrait)
	return begin, begin + codeLen, exceptionList

def readTrait():
	addMultinameToWhiteSet(readS32())
	flag = readUI8()
	readS32List(2)
	if flag & 0x0F in (0, 6):
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

def addStringToBlackSet(index):
	blackSet.add(stringList[index])

def parseABC(tagBody):
	global rawData, offset
	rawData = tagBody
	offset = 4

	del stringLocationList[1:]
	del stringList[1:]
	del namespaceList[1:]
	del namespaceSetList[1:]
	del multinameList[1:]
	
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
		value = _readUI8(offset)
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