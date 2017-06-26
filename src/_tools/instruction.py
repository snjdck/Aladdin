import struct
import avm
from opcode import *

writeS24 = avm.writeS24
writeS32 = avm.writeS32

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
	if flag in [7, 13, 9, 14]: readS32(); readS32()
	elif flag in [15, 16, 27, 28]: readS32()
	elif flag == 29: readS32(); readS32List()
	elif flag not in [17, 18]: assert False, hex(flag)

def readMethodInfo():
	param_count = readS32()
	readS32()
	readS32List(param_count)
	readS32()
	flag = readUI8()
	if flag & 0x08: readS32List([readS32, readUI8])
	if flag & 0x80: readS32List(param_count)

def readInstanceInfo():
	readS32List(2)
	if readUI8() & 0x08: readS32()
	readS32List()
	readMethodIndexAndTrait()

def readMethodBody():
	global offset
	readS32List(5)
	codeLen = readS32()
	begin = offset
	offset += codeLen
	exceptionList = readS32List(lambda:readS32List(5)[2])
	readS32List(readTrait)
	return begin, begin+codeLen, exceptionList

def readTrait():
	readS32()
	flag = readUI8()
	readS32()
	readS32()
	if flag & 0x0F in (0, 6):
		if readS32(): readUI8()
	if flag & 0x40: readS32List()

def readMethodIndexAndTrait(): readS32(); readS32List(readTrait)
def readConstant(reader=None): readS32List(reader, readS32()-1)
def readS32List(reader=None, count=None):
	if count  == None and isinstance(reader, int):
		reader, count = count, reader
	if count  == None: count = readS32()
	if reader == None: reader = readS32
	if hasattr(reader, "__call__"):
		return [reader() for _ in range(count)]
	return [[func() for func in reader] for _ in range(count)]


def parseABC(tagBody):
	global rawData, offset
	rawData = tagBody
	offset = 4
	skipCString()
	offset += 4
	readConstant()
	readConstant()
	readConstant(skipNumber)
	readConstant(skipString)
	readConstant([readUI8, readS32])
	readConstant(readS32List)
	readConstant(readMultiName)
	readS32List(readMethodInfo)
	readS32List([readS32, lambda:readS32List([readS32, readS32])])
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
	for begin, end, exceptionList in methodBodyList:
		codeUsage = {}
		for exception in exceptionList:
			markCodeUsage(begin + exception, end, codeUsage)
		markCodeUsage(begin, end, codeUsage)
		parseInstruction(begin, end, codeUsage)
	return rawData

def _readInstruction(opCode, offset):
	value = None
	if opCode in singleU32Imm:
		value, count = _readS32(offset)
		offset += count
	elif opCode in doubleU32Imm:
		_, count = _readS32(offset)
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

def markCodeUsage(offset, end, codeUsage):
	while offset < end:
		if offset in codeUsage: return
		codeUsage[offset] = True
		opCode = _readUI8(offset)
		if opCode in [OP_returnvoid, OP_returnvalue, OP_throw]: return
		mark = offset
		value, offset = _readInstruction(opCode, offset+1)

		if opCode == OP_jump: offset += calcIndex(offset, value)
		elif opCode in singleS24Imm: markCodeUsage(offset + calcIndex(offset, value), end, codeUsage)
		elif opCode == OP_lookupswitch:
			for base in value: markCodeUsage(mark + calcIndex(mark, base), end, codeUsage)
			return


def parseInstruction(offset, end, codeUsage):
	while offset < end:
		mark = offset
		opCode = _readUI8(offset)
		_, offset = _readInstruction(opCode, offset+1)

		if mark not in codeUsage:
			rawData[mark:offset] = struct.pack("B", OP_nop) * (offset - mark)
		elif opCode in singleS24Imm:
			rawData[mark+1:mark+4] = writeS24(calcIndex(mark+4, _readS24(mark+1)))
		elif opCode == OP_lookupswitch:
			rawData[mark+1:mark+4] = writeS24(calcIndex(mark  , _readS24(mark+1)))
			caseCount, count = _readS32(mark+4)
			for i in range(caseCount+1):
				begin = mark + 4 + count + i * 3
				rawData[begin:begin+3] = writeS24(calcIndex(mark, _readS24(begin)))

	assert offset == end

def calcIndex(offset, index):
	while True:
		if _readUI8(offset + index) == OP_jump:
			index += 4 + _readS24(offset + index + 1)
			continue
		if _readUI8(offset + index) == OP_nop:
			index += 1
			continue
		break
	return index
