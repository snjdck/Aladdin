from enum import Enum, auto
import struct, re

OP_SPECIAL_TEX		= 0x08
OP_SPECIAL_MATRIX	= 0x10
OP_FRAG_ONLY		= 0x20
OP_VERT_ONLY		= 0x40
OP_NO_DEST			= 0x80

class Operation(Enum):
	def __init__(self, code, numRegister, flags=0):
		self.code = code
		self.numRegister = numRegister
		self.flags = flags

	mov = (0x00, 2)									#		=
	add = (0x01, 3)									#		+
	sub = (0x02, 3)									#		-
	mul = (0x03, 3)									#		*
	div = (0x04, 3)									#		/
	rcp = (0x05, 2)									#		1 / n
	min = (0x06, 3)
	max = (0x07, 3)
	frc = (0x08, 2)									#		source1 - floor(source1)
	sqt = (0x09, 2)									#		sqrt(source1)
	rsq = (0x0a, 2)									#		1 / sqrt(source1)
	pow = (0x0b, 3)									#		^
	log = (0x0c, 2)									#		log2(source1)
	exp = (0x0d, 2)									#		2 ^ n
	nrm = (0x0e, 2)
	sin = (0x0f, 2)
	cos = (0x10, 2)
	crs = (0x11, 3)
	dp3 = (0x12, 3)
	dp4 = (0x13, 3)
	abs = (0x14, 2)
	neg = (0x15, 2)									#		-n
	sat = (0x16, 2)									#		max(min(source1,1),0)
	m33 = (0x17, 3, OP_SPECIAL_MATRIX)
	m44 = (0x18, 3, OP_SPECIAL_MATRIX)
	m34 = (0x19, 3, OP_SPECIAL_MATRIX)

	#version 2
	ddx = (0x1a, 2, OP_FRAG_ONLY)
	ddy = (0x1b, 2, OP_FRAG_ONLY)
	ife = (0x1c, 2, OP_NO_DEST)						#		Jump if source1 is equal to source2
	ine = (0x1d, 2, OP_NO_DEST)						#		Jump if source1 is not equal to source2
	ifg = (0x1e, 2, OP_NO_DEST)						#		Jump if source1 is greater or equal than source2
	ifl = (0x1f, 2, OP_NO_DEST)						#		Jump if source1 is less than source2
	els = (0x20, 0, OP_NO_DEST)						#		else
	eif = (0x21, 0, OP_NO_DEST)						#		End an if or else block

	rep = (0x24, 1)									#		repeat vt0.x
	erp = (0x25, 0)									#		end repeat

	ted = (0x26, 3, OP_FRAG_ONLY | OP_SPECIAL_TEX)
	kil = (0x27, 1, OP_FRAG_ONLY | OP_NO_DEST)
	tex = (0x28, 3, OP_FRAG_ONLY | OP_SPECIAL_TEX)
	sge = (0x29, 3)									#		>=
	slt = (0x2a, 3)									#		<
	sgn = (0x2b, 2)									#		(sign) destination = (source1 < 0) ? (-1) : (source1 > 0 ? 1 : 0) - 不支持
	seq = (0x2c, 3)									#		==
	sne = (0x2d, 3)									#		!=
	tld = (0x2e, 3, OP_VERT_ONLY | OP_SPECIAL_TEX)	#src.xy -> uv, src.z -> cubemap side, src.w -> mipmap(0-high)

def char2val(flags, offset=0):
	char = flags[offset]
	if char in ("x", "r", "_"): return 0
	if char in ("y", "g"): return 1
	if char in ("z", "b"): return 2
	if char in ("w", "a"): return 3
	assert False

def flags2swizzle(flags):
	if flags is None or len(flags) <= 0:#03-02-01-00
		return 0xE4
	swizzle = 0
	for i in range(4):
		if i < len(flags):
			shift = char2val(flags, i)
		swizzle |= shift << (i << 1)
	return swizzle

def flags2writeMask(flags):
	if flags is None or len(flags) <= 0:#1111
		return 0xF
	writeMask = 0
	for i in range(len(flags)):
		writeMask |= 1 << char2val(flags, i)
	return writeMask

class ByteWriter:
	def __init__(self):
		self.rawData = bytes()

	def writeHeader(self, shaderType, version):
		self.rawData += struct.pack("<BIBB", 0xa0, version, 0xa1, shaderType)

	def writeOP(self, op):
		self.rawData += struct.pack("<I", op)

	def writeDestinationDummy(self):
		self.rawData += bytes(4)

	def writeSourceDummy(self):
		self.rawData += bytes(8)

	def writeDestination(self, registerType, registerIndex, writeMask):
		self.rawData += struct.pack("<H2B", registerIndex, writeMask, registerType)

	def writeSourceDirect(self, registerType, registerIndex, swizzle):
		self.rawData += struct.pack("<H2BI", registerIndex, 0, swizzle, registerType)

	def writeSourceIndirect(self, registerType, registerIndex, swizzle, indexRegisterType, indirectOffset, indexRegisterComponentSelect):
		self.rawData += struct.pack("<H6B", registerIndex, indirectOffset, swizzle, registerType, indexRegisterType, indexRegisterComponentSelect, 0x80)

	def writeSampler(self, registerIndex, dimension, filter, mipmap, wrapping, format, special):
		self.rawData += struct.pack("<2HB", registerIndex, 0, 5)
		self.rawData += struct.pack("B", format	| (dimension<< 4))
		self.rawData += struct.pack("B", special| (wrapping	<< 4))
		self.rawData += struct.pack("B", mipmap	| (filter	<< 4))

SlotPattern = re.compile(r"^([a-z]{1,3})(\d{0,3})(?:|\.([xyzw_]{1,4}))$")
SamplerPattern = re.compile(r"fs(\d)<([,\w]+)>")
RegisterType = ("va", "xc", "xt", "xo", "v", "fs", "fd", "iid")

class CodeWriter:
	def __init__(self):
		self.writer = ByteWriter()

	def compile(self, target, shaderType, version):
		self.writer.writeHeader(shaderType, version)
		for code in target.output_code: self.writeCode(code)
		target.output_byte = self.writer.rawData

	def writeCode(self, code):
		code = code + [None] * (4 - len(code))
		op = Operation[code[0]]
		assert bool(op.flags & OP_NO_DEST) == (code[1] is None)
		assert op.numRegister == 3 - code.count(None)
		self.writer.writeOP(op.code)
		self.writeDestination(code[1])
		self.writeSource(code[2])
		if op.flags & OP_SPECIAL_TEX:
			self.writeSampler(code[3])
		else:
			self.writeSource(code[3])

	def writeDestination(self, text):
		if text is None:
			self.writer.writeDestinationDummy()
			return
		match = SlotPattern.match(text)
		registerType = RegisterType.index(match[1])
		registerIndex = int(match[2])
		writeMask = flags2writeMask(match[3])
		self.writer.writeDestination(registerType, registerIndex, writeMask)

	def writeSource(self, text):
		if text is None:
			self.writer.writeSourceDummy()
			return
		indirectObj = re.search(r"\[.+\]", text)

		if indirectObj is not None:
			indirectObj = re.search(r"vc\[(va|xt)(\d)\.([xyzw])(\+\d{1,3})?\]", text)
			assert indirectObj is not None
			indexRegisterType = RegisterType.index(indirectObj[1])
			indexRegisterComponentSelect = char2val(indirectObj[3])
			indirectOffset = int(indirectObj[4]) if indirectObj[4] else 0
			text = text.replace(indirectObj[0], "xc" + indirectObj[2])
		match = SlotPattern.match(text)
		registerType = RegisterType.index(match[1])
		registerIndex = int(match[2])
		swizzle = flags2swizzle(match[3])
		if indirectObj is None:
			self.writer.writeSourceDirect(registerType, registerIndex, swizzle)
		else:
			self.writer.writeSourceIndirect(registerType, registerIndex, swizzle,
					indexRegisterType, indirectOffset, indexRegisterComponentSelect)

	def writeSampler(self, text):
		match = SamplerPattern.match(text)
		registerIndex = int(match[1])
		flags = match[2].split(",")

		dimension = 0
		filter = 0
		mipmap = 0
		wrapping = 1
		textureFormat = 0
		special = 0

		for flag in flags:
			flag = flag.lower()
			if flag == "cube": dimension = 1
			elif flag == "3d": dimension = 2
			elif flag == "linear": filter = 1
			elif flag == "mipnearest": mipmap = 1
			elif flag == "miplinear": mipmap = 2
			elif flag == "clamp": wrapping = 0
			elif flag == "repeat": wrapping = 1
			elif flag == "clamp_u_repeat_v": wrapping = 2
			elif flag == "repeat_u_clamp_v": wrapping = 3
			elif flag == "dxt1": textureFormat = 1
			elif flag == "dxt5": textureFormat = 2
			elif flag == "video": textureFormat = 3
			elif flag == "centroid": special |= 1
			elif flag == "single": special |= 2
			elif flag == "ignoresampler": special |= 4

		self.writer.writeSampler(registerIndex, dimension, filter, mipmap, wrapping, textureFormat, special)


class FileWriter:
	def __init__(self):
		self.rawData = bytes()
		self.rawText = ""

	def write(self, vertex, fragment):
		self.writeProgram(vertex)
		self.writeProgram(fragment)
		return self

	def castCodeToStr(self, target):
		self.rawText += f"input = {target.input}\n"
		self.rawText += f"const = {target.const}\n"
		self.rawText += f"data = {target.data}\n"
		self.rawText += f"offset = {target.offset}\n"
		codeList = target.output_code
		for code in codeList:
			self.rawText += " ".join(item for item in code if item is not None)
			self.rawText += "\n"
		self.rawText += "\n"

	def save(self, path):
		with open(f"{path}.agal", "wb") as f:
			f.write(self.rawData)
		with open(f"{path}.txt", "w") as f:
			f.write(self.rawText)

	def writeProgram(self, target):
		self.writeInput(target)
		self.writeConst(target)
		self.writeData(target)
		self.writeCode(target)
		self.castCodeToStr(target)

	def writeInput(self, target):
		items = [None] * len(target.input)
		for k, v in target.input.items():
			items[v[0]] = (k, v[1])
		self.writeByte(len(items))
		for name, format in items:
			self.writeString(name)
			if type(format) is not str:
				format = ""
			self.writeString(format)

	def writeConst(self, target):
		self.writeByte(len(target.const))
		for name, offset in target.const.items():
			self.writeString(name)
			self.writeByte(offset[0])
			self.writeByte(offset[1])

	def writeData(self, target):
		data = target.data.copy()
		while len(data) % 4: data.append(0)
		self.writeByte(len(data) >> 2)
		for value in data:
			self.rawData += struct.pack("<f", value)

	def writeCode(self, target):
		code = target.output_byte
		self.writeShort(len(code))
		self.rawData += code

	def writeShort(self, value):
		self.rawData += struct.pack(">H", value)

	def writeByte(self, value):
		self.rawData += struct.pack("B", value)

	def writeString(self, text):
		self.writeByte(len(text))
		self.rawData += text.encode()