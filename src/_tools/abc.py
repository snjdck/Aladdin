import struct

def readS32(rawData, offset):
	result  = count = 0
	while True:
		byte = rawData[offset + count]
		result |= (byte & 0x7F) << (count * 7)
		count += 1
		if (byte & 0x80) == 0 or count > 4:
			break
	return result, count



def encodeTag(tagType, tagBody):
	tagBodySize = len(tagBody)
	if tagBodySize < 0x3F:
		return struct.pack("<H", (tagType << 6) | tagBodySize) + tagBody
	return struct.pack("<HI", (tagType << 6) | 0x3F, tagBodySize) + tagBody



def genSymbolClassTag():
	tagBody = struct.pack("<H", len(symbol_list))
	for i in range(len(symbol_list)):
		tagBody += struct.pack("<H", i) + symbol_list[i].encode() + b"\x00"
	return encodeTag(76, tagBody);



def calcStringList(export_class_list):
	string_list = set()
	for line in export_class_list:
		index = line.rfind(".")
		if index < 0:
			string_list.add("")
			string_list.add(line)
		else:
			string_list.add(line[0:index])
			string_list.add(line[index+1:])
	return list(string_list)



def calcPacketList(string_list):
	package_list = []
	for i in range(len(string_list)):
		line = string_list[i]
		if len(line) == 0 or line.find(".") >= 0:
			package_list.append(i)
	return package_list



def genDoABC2Tag():
	#export_class_list = ["ImageTest", "flash.display.Sprite", "Object", "flash.events.EventDispatcher", "flash.display.DisplayObject", "flash.display.InteractiveObject", "flash.display.DisplayObjectContainer"]
	string_list = calcStringList(export_class_list)
	package_list = calcPacketList(string_list)

	tagBody = bytes()
	tagBody += b"\x01\x00\x00\x00"
	tagBody += b"\x6d\x65\x72\x67\x65\x64\x00"
	tagBody += b"\x10\x00\x2e\x00"
	tagBody += b"\x00\x00\x00"

	#string cache
	tagBody += struct.pack("B", len(string_list)+1)#use s32
	for line in string_list:
		tagBody += struct.pack("B", len(line)) + line.encode()

	#namespace cache
	tagBody += struct.pack("B", len(package_list)+1)#use s32
	for i in package_list:
		tagBody += struct.pack("2B", 0x16, i+1)

	#multiname cache
	tagBody += struct.pack("2B", 0, len(export_class_list)+1)
	for line in export_class_list:
		index = line.rfind(".")
		if index < 0:
			pIndex = package_list.index(string_list.index(""))
			cIndex = string_list.index(line)
		else:
			pIndex = package_list.index(string_list.index(line[0:index]))
			cIndex = string_list.index(line[index+1:])
		print(pIndex, cIndex)
		tagBody += struct.pack("3B", 7, pIndex+1, cIndex+1)


	#method info
	tagBody += struct.pack("B", len(symbol_list) * 3)
	for symbol in symbol_list:
		symbol_index = string_list.index(symbol) + 1
		tagBody += struct.pack("4B", 0, 0, symbol_index, 0)
		tagBody += struct.pack("4B", 0, 0, 0, 0)
		tagBody += struct.pack("4B", 0, 0, 0, 0)

	#class count
	tagBody += struct.pack("2B", 0, len(symbol_list))
	for symbol in symbol_list:
		symbol_index = export_class_list.index(symbol) + 1
		tagBody += struct.pack("6B", symbol_index, export_class_list.index("flash.display.Sprite")+1, 1, 0, symbol_index * 3 - 2, 0)
	for symbol in symbol_list:
		symbol_index = export_class_list.index(symbol) + 1
		tagBody += struct.pack("2B", symbol_index * 3 - 1, 0)
	#script count
	tagBody += struct.pack("B", len(symbol_list))
	for i in range(len(symbol_list)):
		symbol_index = export_class_list.index(symbol_list[i]) + 1
		tagBody += struct.pack("6B", symbol_index * 3 - 3, 1, symbol_index, 4, 0, i)
	#method count
	tagBody += struct.pack("B", len(symbol_list) * 3)
	for i in range(len(symbol_list)):
		symbol_index = export_class_list.index(symbol_list[i]) + 1
		#constructor
		tagBody += struct.pack("B", i * 3 + 1) + b"\x01\x01\x00\x01"
		tagBody += b"\x06\xd0\x30\xd0\x49\x00"
		tagBody += b"\x47\x00\x00"
		#class init
		tagBody += struct.pack("B", i * 3 + 2) + b"\x00\x01\x00\x00\x01\x47\x00\x00"
		#script init
		tagBody += struct.pack("B", i * 3) + b"\x03\x01\x00\x07"
		tagBody += b"\x22\xd0\x30\x65\x00"
		tagBody += b"\x60" + struct.pack("B", len(symbol_list) + 1)
		tagBody += b"\x30\x60" + struct.pack("B", len(symbol_list) + 2)
		tagBody += b"\x30\x60" + struct.pack("B", len(symbol_list) + 3)
		tagBody += b"\x30\x60" + struct.pack("B", len(symbol_list) + 4)
		tagBody += b"\x30\x60" + struct.pack("B", len(symbol_list) + 5)
		tagBody += b"\x30\x60" + struct.pack("B", len(symbol_list) + 6)
		tagBody += b"\x2a\x30\x58" + struct.pack("B", i)
		tagBody += b"\x1d\x1d\x1d\x1d\x1d\x1d\x68" + struct.pack("B", symbol_index)
		tagBody += b"\x47\x00\x00"

	return encodeTag(82, tagBody)

def main():
	result = bytes()
	result += b"\x78\x00\x04\xe2\x00\x00\x0e\xa6\x00\x00\x18\x01\x00"
	result += b"\x44\x11\x09\x00\x00\x00"
	result += genDoABC2Tag()
	result += genSymbolClassTag()
	result += b"\x40\x00\x00\x00"
	result =  struct.pack("<I", len(result)+8) + result
	result =  b"\x46\x57\x53\x24" + result
	with open("test.swf", "wb") as f:
		f.write(result)


symbol_list = ["ImageTest", "Two"]
export_class_list = symbol_list + ["Object", "flash.events.EventDispatcher", "flash.display.DisplayObject", "flash.display.InteractiveObject", "flash.display.DisplayObjectContainer", "flash.display.Sprite"]
main()
input()