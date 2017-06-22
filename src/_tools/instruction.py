import struct

rawData = None
offset = 0

def readString():
	global rawData, offset
	while rawData[offset] != 0:
		offset += 1
	offset += 1

def _readUI8(offset):
	global rawData
	return rawData[offset]

def _readUI16(offset):
	global rawData
	return struct.unpack_from("<H", rawData, offset)[0]

def _readS24(offset):
	global rawData
	return rawData[offset] | rawData[offset+1] << 8 | struct.unpack_from("b", rawData, offset+2)[0] << 16

def _readS32(offset):
	global rawData
	result = count = 0
	while True:
		byte = rawData[offset + count]
		result |= (byte & 0x7F) << (count * 7)
		count += 1
		if (byte & 0x80) == 0 or count > 4:
			break
	return result, count

def readUI8():
	global offset
	value = _readUI8(offset)
	offset += 1
	return value

def readUI16():
	global offset
	value = _readUI16(offset)
	offset += 2
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

def writeS24(value):
	return struct.pack("2Bb", value & 0xFF, value >> 8 & 0xFF, value >> 16)

def writeS32(value):
	result = bytes()
	while True:
		if value < 0x80:
			result += struct.pack("B", value)
			break
		else:
			result += struct.pack("B", 0x80 | (value & 0xFF))
			value >>= 7
	return result

def readTrait():
	for _ in range(readS32()):
		readS32()
		flag = readUI8()
		readS32()
		readS32()
		if (flag & 0xF) == 0 or (flag & 0xF) == 6:
			if readS32() != 0: readUI8()
		if flag & 0x40:
			for _ in range(readS32()): readS32()

def readMethodIndexAndTrait(): readS32(); readTrait()

def optimize(tagBody):
	global rawData, offset
	rawData = tagBody
	offset = 4
	readString()
	offset += 4
	for _ in range(readS32()-1): readS32()
	for _ in range(readS32()-1): readS32()
	for _ in range(readS32()-1): offset += 8
	for _ in range(readS32()-1): offset = readS32() + offset
	for _ in range(readS32()-1): offset += 1; readS32()
	for _ in range(readS32()-1):
		for _ in range(readS32()): readS32()
	for _ in range(readS32()-1):
		flag = readUI8()
		if flag == 7 or flag == 9 or flag == 14:
			readS32()
			readS32()
		elif flag == 15 or flag == 27 or flag == 28:
			readS32()
		elif flag == 29:
			readS32()
			for _ in range(readS32()): readS32()
		else:
			print(flag)
			break
	for _ in range(readS32()):
		param_count = readS32()
		readS32()
		for _ in range(param_count): readS32()
		readS32()
		flag = readUI8()
		if flag & 0x08:
			for _ in range(readS32()): readS32(); readUI8()
		if flag & 0x80:
			for _ in range(param_count): readS32()
	for _ in range(readS32()):
		readS32()
		for _ in range(readS32()): readS32(); readS32()
	classCount = readS32()
	for _ in range(classCount):
		readS32()
		readS32()
		if readUI8() & 0x08: readS32()
		for _ in range(readS32()): readS32()
		readMethodIndexAndTrait()
	for _ in range(classCount): readMethodIndexAndTrait()
	for _ in range(readS32()):  readMethodIndexAndTrait()

	end = offset
	result = rawData[:end]
	for _ in range(readS32()):
		methodID = readS32()
		for _ in range(4): readS32()
		codeLen = readS32()
		result += rawData[end:offset]
		begin, end = offset, offset + codeLen
		offset = end

		exceptionList = []
		for _ in range(readS32()):
			readS32(); readS32()
			exceptionList.append(readS32())
			readS32(); readS32()
		readTrait()
		
		codeUsage = {}
		for exception in exceptionList:
			markCodeUsage(begin + exception, end, codeUsage)
		markCodeUsage(begin, end, codeUsage)

		begin, offset = offset, begin
		result += parseInstruction(methodID, codeUsage, end)
		offset = begin

	result += rawData[end:]
	assert len(rawData) == offset
	return result

def markCodeUsage(begin, end, codeUsage):
	offset = begin
	while offset < end:
		if offset in codeUsage:
			return
		codeUsage[offset] = True
		opCode = _readUI8(offset)
		offset += 1
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
			base = offset - 1
			value = [base + _readS24(offset)]
			offset += 3
			caseCount, count = _readS32(offset)
			offset += count
			for _ in range(caseCount+1):
				value.append(base + _readS24(offset))
				offset += 3

		if opCode == OP_jump:
			offset += value
		elif opCode in singleS24Imm:
			markCodeUsage(offset + value, end, codeUsage)
		elif opCode == OP_returnvoid or opCode == OP_returnvalue or opCode == OP_throw:
			return
		elif opCode == OP_lookupswitch:
			for base in value:
				markCodeUsage(base, end, codeUsage)
			return


def parseInstruction(methodID, codeUsage, end):
	global rawData, offset
	begin = offset

	result = bytes()

	while offset < end:
		mark = offset
		opCode = readUI8()

		if mark not in codeUsage:
			readInstructionData(opCode)
			for _ in range(offset - mark):
				result += struct.pack("B", OP_nop)
		elif opCode == OP_setlocal or opCode == OP_getlocal:
			index = readS32()
			if index < 4:
				op = OP_setlocal0 if opCode == OP_setlocal else OP_getlocal0
				result += struct.pack("2B", op + index, OP_nop)
			else:
				result += rawData[mark:offset]
		elif opCode in singleS24Imm:
			index = readS24()
			while rawData[offset + index] == OP_jump:
				index += 4 + _readS24(offset + index + 1)
			result += struct.pack("B", opCode) + writeS24(index)
		else:
			readInstructionData(opCode)
			result += rawData[mark:offset]

	assert offset == end
	return result

def readInstructionData(opCode):
	global rawData, offset
	if opCode in singleU32Imm:    readS32()
	elif opCode in doubleU32Imm:  readS32(); readS32()
	elif opCode in singleS24Imm:  readS24()
	elif opCode in singleByteImm: readUI8()
	elif opCode == OP_debug:
		readUI8()
		readS32()
		readUI8()
		readS32()
	elif opCode == OP_lookupswitch:
		readS24()
		for _ in range(readS32()+1): readS24()

OP_bkpt = 0x01
OP_nop = 0x02
OP_throw = 0x03
OP_getsuper = 0x04
OP_setsuper = 0x05
OP_dxns = 0x06
OP_dxnslate = 0x07
OP_kill = 0x08
OP_label = 0x09
OP_ifnlt = 0x0C
OP_ifnle = 0x0D
OP_ifngt = 0x0E
OP_ifnge = 0x0F
OP_jump = 0x10
OP_iftrue = 0x11
OP_iffalse = 0x12
OP_ifeq = 0x13
OP_ifne = 0x14
OP_iflt = 0x15
OP_ifle = 0x16
OP_ifgt = 0x17
OP_ifge = 0x18
OP_ifstricteq = 0x19
OP_ifstrictne = 0x1A
OP_lookupswitch = 0x1B
OP_pushwith = 0x1C
OP_popscope = 0x1D
OP_nextname = 0x1E
OP_hasnext = 0x1F
OP_pushnull = 0x20
OP_pushundefined = 0x21
OP_pushconstant = 0x22
OP_nextvalue = 0x23
OP_pushbyte = 0x24
OP_pushshort = 0x25
OP_pushtrue = 0x26
OP_pushfalse = 0x27
OP_pushnan = 0x28
OP_pop = 0x29
OP_dup = 0x2A
OP_swap = 0x2B
OP_pushstring = 0x2C
OP_pushint = 0x2D
OP_pushuint = 0x2E
OP_pushdouble = 0x2F
OP_pushscope = 0x30
OP_pushnamespace = 0x31
OP_hasnext2 = 0x32
OP_li8 = 0x35
OP_li16 = 0x36
OP_li32 = 0x37
OP_lf32 = 0x38
OP_lf64 = 0x39
OP_si8 = 0x3A
OP_si16 = 0x3B
OP_si32 = 0x3C
OP_sf32 = 0x3D
OP_sf64 = 0x3E
OP_newfunction = 0x40
OP_call = 0x41
OP_construct = 0x42
OP_callmethod = 0x43
OP_callstatic = 0x44
OP_callsuper = 0x45
OP_callproperty = 0x46
OP_returnvoid = 0x47
OP_returnvalue = 0x48
OP_constructsuper = 0x49
OP_constructprop = 0x4A
OP_callsuperid = 0x4B
OP_callproplex = 0x4C
OP_callinterface = 0x4D
OP_callsupervoid = 0x4E
OP_callpropvoid = 0x4F
OP_sxi1 = 0x50
OP_sxi8 = 0x51
OP_sxi16 = 0x52
OP_applytype = 0x53
OP_newobject = 0x55
OP_newarray = 0x56
OP_newactivation = 0x57
OP_newclass = 0x58
OP_getdescendants = 0x59
OP_newcatch = 0x5A
OP_findpropstrict = 0x5D
OP_findproperty = 0x5E
OP_finddef = 0x5F
OP_getlex = 0x60
OP_setproperty = 0x61
OP_getlocal = 0x62
OP_setlocal = 0x63
OP_getglobalscope = 0x64
OP_getscopeobject = 0x65
OP_getproperty = 0x66
OP_getouterscope = 0x67
OP_initproperty = 0x68
OP_setpropertylate = 0x69
OP_deleteproperty = 0x6A
OP_deletepropertylate = 0x6B
OP_getslot = 0x6C
OP_setslot = 0x6D
OP_getglobalslot = 0x6E
OP_setglobalslot = 0x6F
OP_convert_s = 0x70
OP_esc_xelem = 0x71
OP_esc_xattr = 0x72
OP_convert_i = 0x73
OP_convert_u = 0x74
OP_convert_d = 0x75
OP_convert_b = 0x76
OP_convert_o = 0x77
OP_checkfilter = 0x78
OP_coerce = 0x80
OP_coerce_b = 0x81
OP_coerce_a = 0x82
OP_coerce_i = 0x83
OP_coerce_d = 0x84
OP_coerce_s = 0x85
OP_astype = 0x86
OP_astypelate = 0x87
OP_coerce_u = 0x88
OP_coerce_o = 0x89
OP_negate = 0x90
OP_increment = 0x91
OP_inclocal = 0x92
OP_decrement = 0x93
OP_declocal = 0x94
OP_typeof = 0x95
OP_not = 0x96
OP_bitnot = 0x97
OP_concat = 0x9A
OP_add_d = 0x9B
OP_add = 0xA0
OP_subtract = 0xA1
OP_multiply = 0xA2
OP_divide = 0xA3
OP_modulo = 0xA4
OP_lshift = 0xA5
OP_rshift = 0xA6
OP_urshift = 0xA7
OP_bitand = 0xA8
OP_bitor = 0xA9
OP_bitxor = 0xAA
OP_equals = 0xAB
OP_strictequals = 0xAC
OP_lessthan = 0xAD
OP_lessequals = 0xAE
OP_greaterthan = 0xAF
OP_greaterequals = 0xB0
OP_instanceof = 0xB1
OP_istype = 0xB2
OP_istypelate = 0xB3
OP_in = 0xB4
OP_increment_i = 0xC0
OP_decrement_i = 0xC1
OP_inclocal_i = 0xC2
OP_declocal_i = 0xC3
OP_negate_i = 0xC4
OP_add_i = 0xC5
OP_subtract_i = 0xC6
OP_multiply_i = 0xC7
OP_getlocal0 = 0xD0
OP_getlocal1 = 0xD1
OP_getlocal2 = 0xD2
OP_getlocal3 = 0xD3
OP_setlocal0 = 0xD4
OP_setlocal1 = 0xD5
OP_setlocal2 = 0xD6
OP_setlocal3 = 0xD7
OP_debug = 0xEF
OP_debugline = 0xF0
OP_debugfile = 0xF1
OP_bkptline = 0xF2
OP_timestamp = 0xF3


opNames = [
"OP_0x00       ",
"bkpt          ",
"nop           ",
"throw         ",
"getsuper      ",
"setsuper      ",
"dxns          ",
"dxnslate      ",
"kill          ",
"label         ",
"OP_0x0A       ",
"OP_0x0B       ",
"ifnlt         ",
"ifnle         ",
"ifngt         ",
"ifnge         ",
"jump          ",
"iftrue        ",
"iffalse       ",
"ifeq          ",
"ifne          ",
"iflt          ",
"ifle          ",
"ifgt          ",
"ifge          ",
"ifstricteq    ",
"ifstrictne    ",
"lookupswitch  ",
"pushwith      ",
"popscope      ",
"nextname      ",
"hasnext       ",
"pushnull      ",
"pushundefined ",
"pushconstant  ",
"nextvalue     ",
"pushbyte      ",
"pushshort     ",
"pushtrue      ",
"pushfalse     ",
"pushnan       ",
"pop           ",
"dup           ",
"swap          ",
"pushstring    ",
"pushint       ",
"pushuint      ",
"pushdouble    ",
"pushscope     ",
"pushnamespace ",
"hasnext2      ",
"OP_0x33       ",
"OP_0x34       ",
"li8           ",
"li16          ",
"li32          ",
"lf32          ",
"lf64          ",
"si8           ",
"si16          ",
"si32          ",
"sf32          ",
"sf64          ",
"OP_0x3F       ",
"newfunction   ",
"call          ",
"construct     ",
"callmethod    ",
"callstatic    ",
"callsuper     ",
"callproperty  ",
"returnvoid    ",
"returnvalue   ",
"constructsuper",
"constructprop ",
"callsuperid   ",
"callproplex   ",
"callinterface ",
"callsupervoid ",
"callpropvoid  ",
"sxi1          ",
"sxi8          ",
"sxi16         ",
"applytype     ",
"OP_0x54       ",
"newobject     ",
"newarray      ",
"newactivation ",
"newclass      ",
"getdescendants",
"newcatch      ",
"OP_0x5B       ", # findpropglobalstrict (internal)
"OP_0x5C       ", # findpropglobal (internal)
"findpropstrict",
"findproperty  ",
"finddef       ",
"getlex        ",
"setproperty   ",
"getlocal      ",
"setlocal      ",
"getglobalscope",
"getscopeobject",
"getproperty   ",
"getouterscope ",
"initproperty  ",
"OP_0x69       ",
"deleteproperty",
"OP_0x6B       ",
"getslot       ",
"setslot       ",
"getglobalslot ",
"setglobalslot ",
"convert_s     ",
"esc_xelem     ",
"esc_xattr     ",
"convert_i     ",
"convert_u     ",
"convert_d     ",
"convert_b     ",
"convert_o     ",
"checkfilter   ",
"OP_0x79       ",
"OP_0x7A       ",
"OP_0x7B       ",
"OP_0x7C       ",
"OP_0x7D       ",
"OP_0x7E       ",
"OP_0x7F       ",
"coerce        ",
"coerce_b      ",
"coerce_a      ",
"coerce_i      ",
"coerce_d      ",
"coerce_s      ",
"astype        ",
"astypelate    ",
"coerce_u      ",
"coerce_o      ",
"OP_0x8A       ",
"OP_0x8B       ",
"OP_0x8C       ",
"OP_0x8D       ",
"OP_0x8E       ",
"OP_0x8F       ",
"negate        ",
"increment     ",
"inclocal      ",
"decrement     ",
"declocal      ",
"typeof        ",
"not           ",
"bitnot        ",
"OP_0x98       ",
"OP_0x99       ",
"concat        ",
"add_d         ",
"OP_0x9C       ",
"OP_0x9D       ",
"OP_0x9E       ",
"OP_0x9F       ",
"add           ",
"subtract      ",
"multiply      ",
"divide        ",
"modulo        ",
"lshift        ",
"rshift        ",
"urshift       ",
"bitand        ",
"bitor         ",
"bitxor        ",
"equals        ",
"strictequals  ",
"lessthan      ",
"lessequals    ",
"greaterthan   ",
"greaterequals ",
"instanceof    ",
"istype        ",
"istypelate    ",
"in            ",
"OP_0xB5       ",
"OP_0xB6       ",
"OP_0xB7       ",
"OP_0xB8       ",
"OP_0xB9       ",
"OP_0xBA       ",
"OP_0xBB       ",
"OP_0xBC       ",
"OP_0xBD       ",
"OP_0xBE       ",
"OP_0xBF       ",
"increment_i   ",
"decrement_i   ",
"inclocal_i    ",
"declocal_i    ",
"negate_i      ",
"add_i         ",
"subtract_i    ",
"multiply_i    ",
"OP_0xC8       ",
"OP_0xC9       ",
"OP_0xCA       ",
"OP_0xCB       ",
"OP_0xCC       ",
"OP_0xCD       ",
"OP_0xCE       ",
"OP_0xCF       ",
"getlocal0     ",
"getlocal1     ",
"getlocal2     ",
"getlocal3     ",
"setlocal0     ",
"setlocal1     ",
"setlocal2     ",
"setlocal3     ",
"OP_0xD8       ",
"OP_0xD9       ",
"OP_0xDA       ",
"OP_0xDB       ",
"OP_0xDC       ",
"OP_0xDD       ",
"OP_0xDE       ",
"OP_0xDF       ",
"OP_0xE0       ",
"OP_0xE1       ",
"OP_0xE2       ",
"OP_0xE3       ",
"OP_0xE4       ",
"OP_0xE5       ",
"OP_0xE6       ",
"OP_0xE7       ",
"OP_0xE8       ",
"OP_0xE9       ",
"OP_0xEA       ",
"OP_0xEB       ",
"OP_0xEC       ",
"OP_0xED       ",
"OP_0xEE       ",
"debug         ",
"debugline     ",
"debugfile     ",
"bkptline      ",
"timestamp     ",
"OP_0xF4       ",
"OP_0xF5       ",
"OP_0xF6       ",
"OP_0xF7       ",
"OP_0xF8       ",
"OP_0xF9       ",
"OP_0xFA       ",
"OP_0xFB       ",
"OP_0xFC       ",
"OP_0xFD       ",
"OP_0xFE       ",
"OP_0xFF       "
]


singleU32Imm = [ OP_debugfile, OP_pushstring, OP_pushnamespace,
  OP_pushint, OP_pushuint, OP_pushdouble, OP_getsuper, OP_setsuper,
  OP_getproperty, OP_initproperty, OP_setproperty, OP_getlex,
  OP_findpropstrict, OP_findproperty, OP_finddef, OP_deleteproperty,
  OP_istype, OP_coerce, OP_astype, OP_getdescendants, OP_newfunction,
  OP_newclass, OP_inclocal, OP_declocal, OP_inclocal_i, OP_declocal_i,
  OP_getlocal, OP_kill, OP_setlocal, OP_debugline, OP_getglobalslot,
  OP_getslot, OP_setglobalslot, OP_setslot, OP_pushshort, OP_newcatch,
  OP_newobject, OP_newarray, OP_call, OP_construct, OP_constructsuper,
  OP_applytype, OP_dxns, OP_bkptline ]

doubleU32Imm = [ OP_callstatic, OP_constructprop, OP_callproperty,
  OP_callproplex, OP_callsuper, OP_callsupervoid, OP_callpropvoid,
  OP_callmethod, OP_hasnext2 ]

singleS24Imm = [ OP_jump, OP_iftrue, OP_iffalse, OP_ifeq, OP_ifne,
  OP_ifge, OP_ifnge, OP_ifgt, OP_ifngt, OP_ifle, OP_ifnle, OP_iflt,
  OP_ifnlt, OP_ifstricteq, OP_ifstrictne ]

singleByteImm = [ OP_pushbyte, OP_getscopeobject ]