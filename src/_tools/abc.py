import struct
import sys
import os

from swf import *

def readS32(rawData, offset):
	result  = count = 0
	while True:
		byte = rawData[offset + count]
		result |= (byte & 0x7F) << (count * 7)
		count += 1
		if (byte & 0x80) == 0 or count > 4:
			break
	return result, count


def writeS32(value):
	if value < 0x80:
		return struct.pack("B", value)
	return struct.pack("2B", 0x80 | (value & 0xFF), value >> 7)


def encodeTag(tagType, tagBody):
	tagBodySize = len(tagBody)
	if tagBodySize < 0x3F:
		return struct.pack("<H", (tagType << 6) | tagBodySize) + tagBody
	return struct.pack("<HI", (tagType << 6) | 0x3F, tagBodySize) + tagBody



def genImageTag(id, path):
	with open(path, "rb") as f:
		data = f.read()
	tagBody = struct.pack("<H", id) + data
	return encodeTag(21, tagBody);



def genSymbolClassTag(symbol_list):
	tagBody = struct.pack("<H", len(symbol_list))
	for i in range(len(symbol_list)):
		tagBody += struct.pack("<H", i+1) + symbol_list[i].encode() + b"\x00"
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


def genDoABC2Tag(symbol_list):
	export_class_list = symbol_list + ["Object", "flash.events.EventDispatcher", "flash.display.DisplayObject", "flash.display.Bitmap"]
	string_list = calcStringList(export_class_list)
	package_list = calcPacketList(string_list)

	tagBody = bytes()
	tagBody += b"\x01\x00\x00\x00"
	tagBody += b"\x00"
	tagBody += b"\x10\x00\x2e\x00"
	tagBody += b"\x00\x00\x00"

	#string cache
	tagBody += writeS32(len(string_list)+1)
	for line in string_list:
		tagBody += writeS32(len(line)) + line.encode()

	#namespace cache
	tagBody += writeS32(len(package_list)+1)
	for i in package_list:
		tagBody += struct.pack("B", 0x16)
		tagBody += writeS32(i+1)

	#ns set
	tagBody += writeS32(0)

	#multiname cache
	tagBody += writeS32(len(export_class_list)+1)
	for line in export_class_list:
		index = line.rfind(".")
		if index < 0:
			pIndex = package_list.index(string_list.index(""))
			cIndex = string_list.index(line)
		else:
			pIndex = package_list.index(string_list.index(line[0:index]))
			cIndex = string_list.index(line[index+1:])
		tagBody += struct.pack("B", 7)
		tagBody += writeS32(pIndex+1)
		tagBody += writeS32(cIndex+1)


	#method info
	tagBody += writeS32(len(symbol_list) * 2 + 1)
	tagBody += struct.pack("I", 0)
	for symbol in symbol_list:
		tagBody += struct.pack("2I", 0, 0)

	#metadata
	tagBody += writeS32(0)

	#class count
	tagBody += writeS32(len(symbol_list))
	for i in range(len(symbol_list)):
		tagBody += writeS32(i + 1)
		tagBody += writeS32(len(export_class_list))
		tagBody += struct.pack("B", 1)
		tagBody += writeS32(0)
		tagBody += writeS32(i * 2 + 1)
		tagBody += writeS32(0)
	for i in range(len(symbol_list)):
		tagBody += writeS32(i * 2 + 2)
		tagBody += writeS32(0)

	#script count
	tagBody += writeS32(1)
	tagBody += writeS32(0)
	tagBody += writeS32(len(symbol_list))
	for i in range(len(symbol_list)):
		tagBody += writeS32(i + 1)
		tagBody += struct.pack("2B", 4, 0)
		tagBody += writeS32(i)

	#method count
	tagBody += writeS32(len(symbol_list) * 2 + 1)

	for i in range(len(symbol_list)):
		tagBody += writeS32(i * 2 + 1) + b"\x00\x01\x00\x00\x01\x47\x00\x00"
		tagBody += writeS32(i * 2 + 2) + b"\x00\x01\x00\x00\x01\x47\x00\x00"

	#script init
	tagBody += b"\x00\x02\x01\x00\x05"
	instruction  = b"\xd0\x30"
	instruction += b"\x60" + writeS32(len(symbol_list) + 1) + b"\x30"
	instruction += b"\x60" + writeS32(len(symbol_list) + 2) + b"\x30"
	instruction += b"\x60" + writeS32(len(symbol_list) + 3) + b"\x30"
	instruction += b"\x60" + writeS32(len(symbol_list) + 4) + b"\x30"
	for i in range(len(symbol_list)):
		instruction += b"\xd0\x65\x04\x58" + writeS32(i)
		instruction += b"\x68" + writeS32(i + 1)
	instruction += b"\x47"
	tagBody += writeS32(len(instruction))
	tagBody += instruction
	tagBody += b"\x00\x00"

	return encodeTag(82, tagBody)


def calcClassName(filePath):
	name = filePath
	index = name.rfind(".")
	if index >= 0:
		name = name[1+index:] + "/" + name[0:index]
	name = name.replace(".", "_")
	name = name.replace("/", ".")
	name = name.replace("\\", ".")
	return name
	return "assets.images." + name


def main(filePath):
	if not os.path.exists(filePath):
		return "file not exist."

	symbol_list = []
	path_list = []
	if os.path.isfile(filePath):
		symbol_list.append(calcClassName(os.path.basename(filePath)))
		path_list.append(filePath)
	else:
		for parent, dirnames, filenames in os.walk(filePath):
			for filename in filenames:
				path = os.path.join(parent, filename)
				filename = os.path.relpath(path, filePath)
				symbol_list.append(calcClassName(filename))
				path_list.append(path)

	result = bytes()
	result += b"\x08\x00\x00\x18\x01\x00"
	result += b"\x44\x11\x09\x00\x00\x00"
	for i in range(len(symbol_list)):
		result += genImageTag(i+1, path_list[i])
	result += genDoABC2Tag(symbol_list)
	result += genSymbolClassTag(symbol_list)
	result += b"\x40\x00\x00\x00"
	with open(os.path.dirname(filePath) + "/test.swf", "wb") as f:
		f.write(encodeLzmaSWF(result, 0))

	return "success."



if __name__ == "__main__":
	input(main(sys.argv[1]))