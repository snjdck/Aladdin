import struct
import sys
import os

from swf import *
from image import *

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


def parseImage(data):
	if isPNG(data):
		return optimizePNG(data)
	return data


def genImageTag(id, path):
	with open(path, "rb") as f:
		data = parseImage(f.read())
	tagBody = struct.pack("<H", id) + data
	return encodeTag(21, tagBody);



def genSymbolClassTag(symbol_list):
	tagBody = struct.pack("<H", len(symbol_list))
	for i in range(len(symbol_list)):
		tagBody += struct.pack("<H", i+1) + symbol_list[i].encode() + b"\x00"
	return encodeTag(76, tagBody);



def calcStringList(export_class_list):
	package_list = set()
	string_list = set()
	for line in export_class_list:
		index = line.rfind(".")

		if index < 0:
			package = ""
			string_list.add(line)
		else:
			package = line[:index]
			string_list.add(line[index+1:])

		package_list.add(package)
		string_list.add(package)

	return list(string_list), list(package_list)



def genDoABC2Tag(symbol_list):
	export_class_list = symbol_list + ["Object", "flash.events.EventDispatcher", "flash.display.DisplayObject", "flash.display.Bitmap"]
	string_list, package_list = calcStringList(export_class_list)

	tagBody = bytes.fromhex("01 00 00 00 00 10 00 2e 00 00 00 00")

	#string cache
	tagBody += writeS32(len(string_list)+1)
	for line in string_list:
		tagBody += writeS32(len(line)) + line.encode()

	#namespace cache
	tagBody += writeS32(len(package_list)+1)
	for line in package_list:
		tagBody += struct.pack("B", 0x16)
		tagBody += writeS32(string_list.index(line) + 1)

	#ns set
	tagBody += writeS32(0)

	#multiname cache
	tagBody += writeS32(len(export_class_list)+1)
	for line in export_class_list:
		index = line.rfind(".")
		if index < 0:
			pIndex = package_list.index("")
			cIndex = string_list.index(line)
		else:
			pIndex = package_list.index(line[:index])
			cIndex = string_list.index(line[index+1:])
		tagBody += struct.pack("B", 7)
		tagBody += writeS32(pIndex+1)
		tagBody += writeS32(cIndex+1)


	#method info
	count = len(symbol_list) * 2 + 1
	tagBody += writeS32(count) + bytes(count * 4)

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
		tagBody += writeS32(i * 2 + 1) + bytes.fromhex("00 01 00 00 01 47 00 00")
		tagBody += writeS32(i * 2 + 2) + bytes.fromhex("00 01 00 00 01 47 00 00")

	#script init
	tagBody += bytes.fromhex("00 02 01 00 05")
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

	result = bytes.fromhex("08 00 00 18 01 00") + bytes.fromhex("44 11 09 00 00 00")
	for i in range(len(symbol_list)):
		result += genImageTag(i+1, path_list[i])
	result += genDoABC2Tag(symbol_list)
	result += genSymbolClassTag(symbol_list)
	result += bytes.fromhex("40 00 00 00")
	with open(os.path.dirname(filePath) + "/test.swf", "wb") as f:
		f.write(encodeLzmaSWF(result, 0))

	return "success."



if __name__ == "__main__":
	input(main(sys.argv[1]))