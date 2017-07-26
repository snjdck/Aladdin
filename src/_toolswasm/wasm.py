import struct
import dis

def add(a: int, b: int) -> int:
	return a + b

def square(a: int) -> int:
	return a * a

def genSection(sid, data):
	return struct.pack("2B", sid, len(data)) + data

def genFuncBody(func):
	data = b"\x00"
	for code in dis.Bytecode(func):
		if code.opname == "LOAD_FAST":
			data += struct.pack("2B", 0x20, code.arg)
		elif code.opname == "BINARY_ADD":
			data += struct.pack("B", 0x6A)
		elif code.opname == "BINARY_MULTIPLY":
			data += struct.pack("B", 0x6C)
		elif code.opname == "RETURN_VALUE":
			data += struct.pack("B", 0x0F)
	return data + b"\x0B"

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

print(" ".join([hex(item)[2:].zfill(2) for item in output]))

input()