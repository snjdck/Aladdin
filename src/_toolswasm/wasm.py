import struct
import dis

__all__ = ("add", "square")

output = struct.pack("<2I", 0x6d736100, 1)

def add(a: int, b: int) -> int:
	return a + b

def square(a: int) -> int:
	return a * a

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
output += struct.pack("2B", 1, len(info)) + info

info = struct.pack("B", len(funcInfoList))
for i in range(len(funcInfoList)):
	info += struct.pack("B", i)
output += struct.pack("2B", 3, len(info)) + info

info = struct.pack("B", len(funcInfoList))
for i in range(len(funcInfoList)):
	name = funcInfoList[i].__name__
	info += struct.pack("B", len(name))
	info += name.encode()
	info += struct.pack("2B", 0, i)
output += struct.pack("2B", 7, len(info)) + info

info = struct.pack("B", len(funcInfoList))
for func in funcInfoList:
	funcInfo = b"\x00"
	for code in dis.Bytecode(func):
		if code.opname == "LOAD_FAST":
			funcInfo += struct.pack("2B", 0x20, code.arg)
		elif code.opname == "BINARY_ADD":
			funcInfo += struct.pack("B", 0x6A)
		elif code.opname == "BINARY_MULTIPLY":
			funcInfo += struct.pack("B", 0x6C)
		elif code.opname == "RETURN_VALUE":
			funcInfo += struct.pack("B", 0x0F)
	funcInfo += b"\x0B"
	info += struct.pack("B", len(funcInfo)) + funcInfo

output += struct.pack("2B", 10, len(info)) + info

print(" ".join([hex(item)[2:].zfill(2) for item in output]))



#print(ast.dump(tree))
#input()