import struct
import dis

code_global = []

def add(a: int, b: int) -> int:
	return a + b

def square(a: int) -> int:
	return a * a

def fac(a: int) -> int:
	if a < 1: return 1
	return a * fac(a - 1)

def findCode(codeList, offset):
	for i, code in enumerate(codeList):
		if code.offset == offset:
			assert code.is_jump_target
			return i
	assert False

def genSection(sid, data):
	return struct.pack("2B", sid, len(data)) + data

def genCodeList(codeList, begin=0, end=None):
	if end is None: end = len(codeList)
	data = bytes()
	index = begin
	while index < end:
		code = codeList[index]
		if code.opname == "LOAD_FAST":
			data += struct.pack("2B", 0x20, code.arg)
		elif code.opname == "BINARY_ADD":
			data += struct.pack("B", 0x6A)
		elif code.opname == "BINARY_SUBTRACT":
			data += struct.pack("B", 0x6B)
		elif code.opname == "BINARY_MULTIPLY":
			data += struct.pack("B", 0x6C)
		elif code.opname == "RETURN_VALUE":
			data += struct.pack("B", 0x0F)
		elif code.opname == "LOAD_CONST":
			data += struct.pack("2B", 0x41, code.arg)
		elif code.opname == "LOAD_GLOBAL":
			code_global.append(code.argval)
		elif code.opname == "COMPARE_OP":
			if code.argval == "<":
				data += struct.pack("B", 0x4C)
			else: assert False, code
		elif code.opname == "POP_JUMP_IF_FALSE":
			offset = findCode(codeList, code.argval)
			data += struct.pack("2B", 0x04, 0x7F)
			data += genCodeList(codeList, index+1, offset)
			data += struct.pack("B", 0x0B)
			index = offset
			continue
		elif code.opname == "CALL_FUNCTION":
			data += struct.pack("2B", 0x10, __all__.index(code_global.pop()))
		else: assert False, code
		index += 1
	return data

def genFuncBody(func):
	codeList = list(dis.Bytecode(func))
	for code in codeList:
		print(code)
	return b"\x00" + genCodeList(codeList) + b"\x0B"

__all__ = ("add", "square")
output = struct.pack("<2I", 0x6d736100, 1)
funcInfoList = [globals()[node] for node in __all__]

info = struct.pack("B", len(funcInfoList))
for func in funcInfoList:
	annotations = func.__annotations__
	info += b"\x60"
	argCount = len(annotations) - 1
	info += struct.pack("B", argCount)
	for i in range(argCount):
		info += struct.pack("B", 0x7F)
	info += struct.pack("B", 1)
	info += struct.pack("B", 0x7F)
output += genSection(1, info)

info = struct.pack("B", len(funcInfoList))
for i in range(len(funcInfoList)):
	info += struct.pack("B", i)
output += genSection(3, info)

info = struct.pack("B", len(funcInfoList))
for i in range(len(funcInfoList)):
	name = funcInfoList[i].__name__
	info += struct.pack("B", len(name))
	info += name.encode()
	info += struct.pack("2B", 0, i)
output += genSection(7, info)

info = struct.pack("B", len(funcInfoList))
for func in funcInfoList:
	data = genFuncBody(func)
	info += struct.pack("B", len(data)) + data

output += genSection(10, info)

input(
"WebAssembly.compile(new Uint8Array(["
+ ", ".join(["0x" + hex(item)[2:].zfill(2) for item in output]) +
"""
])).then(module=>{
  const instance = new WebAssembly.Instance(module)
  const {add, square} = instance.exports
  console.log('2 + 4 =', add(2, 4))
  console.log('3^2 =', square(3))
  console.log('(2 + 5)^2 =', square(add(2+5)))
})
""")