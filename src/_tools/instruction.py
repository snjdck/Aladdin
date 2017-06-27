import struct
from opcode import *
from avm2 import *
import avm2


def optimize(tagBody):
	methodBodyList = parseABC(tagBody)
	rawData = bytearray(tagBody)
	for begin, end, exceptionList in methodBodyList:
		codeUsage = {}
		for exception in exceptionList:
			markCodeUsage(begin + exception, end, codeUsage)
		markCodeUsage(begin, end, codeUsage)
		parseInstruction(rawData, begin, end, codeUsage)
	return rawData


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


def parseInstruction(rawData, offset, end, codeUsage):
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
