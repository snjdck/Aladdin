import struct
import sys
import os

from swf import *
from swf_tag import *


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

def isImage(path):
	ext = os.path.splitext(path)[1]
	return ext == ".png" or ext == ".jpg" or ext == ".gif"

def genAssetTag(id, path):
	with open(path, "rb") as f:
		data = f.read()
	if isImage(path):
		return genImageTag(id, data)
	return genBinaryTag(id, data)


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


def genNewClassInstruction(index, name_offset, scopeIndex):
	instruction =  b"\xd0"
	instruction += b"\x65" + writeS32(scopeIndex)
	instruction += b"\x58" + writeS32(index)
	instruction += b"\x68" + writeS32(index + name_offset)
	return instruction

def genDoABC2Tag(symbol_list, path_list):
	bitmap_count = len([path for path in path_list if isImage(path)])
	bitmap_flag = bitmap_count > 0
	bytearray_flag = bitmap_count < len(symbol_list)

	if bitmap_flag and bytearray_flag:
		reserved = ["Object", "flash.events.EventDispatcher", "flash.display.DisplayObject", "flash.display.Bitmap", "flash.utils.ByteArray"]
	elif bitmap_flag:
		reserved = ["Object", "flash.events.EventDispatcher", "flash.display.DisplayObject", "flash.display.Bitmap"]
	elif bytearray_flag:
		reserved = ["Object", "flash.utils.ByteArray"]

	
	name_offset = len(reserved) + 1
	if bitmap_flag:
		bitmap_index    = 1 + reserved.index("flash.display.Bitmap")
	if bytearray_flag:
		bytearray_index = 1 + reserved.index("flash.utils.ByteArray")
	
	export_class_list = reserved + symbol_list
	string_list, package_list = calcStringList(export_class_list)

	tagBody = bytes.fromhex("01 00 00 00 00 10 00 2e 00 00 00 00")

	#string cache
	tagBody += writeS32(len(string_list)+1)
	for line in string_list:
		tagBody += writeS32(len(line)) + line.encode()

	#namespace cache
	tagBody += writeS32(len(package_list)+1)
	for line in package_list:
		tagBody += b"\x16" + writeS32(string_list.index(line) + 1)

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
		tagBody += b"\x07" + writeS32(pIndex+1) + writeS32(cIndex+1)


	#method info
	count = len(symbol_list) * 2 + 1
	tagBody += writeS32(count) + bytes(count * 4)

	#metadata
	tagBody += writeS32(0)

	#class count
	tagBody += writeS32(len(symbol_list))
	for i in range(len(symbol_list)):
		tagBody += writeS32(i + name_offset)
		tagBody += writeS32(bitmap_index if isImage(path_list[i]) else bytearray_index)
		tagBody += b"\x01\x00"
		tagBody += writeS32(i * 2 + 1) + b"\x00"
	for i in range(len(symbol_list)):
		tagBody += writeS32(i * 2 + 2) + b"\x00"

	#script count
	tagBody += b"\x01\x00"
	tagBody += writeS32(len(symbol_list))
	for i in range(len(symbol_list)):
		tagBody += writeS32(i + name_offset)
		tagBody += b"\x04\x00"
		tagBody += writeS32(i)

	#method count
	tagBody += writeS32(len(symbol_list) * 2 + 1)

	for i in range(len(symbol_list)):
		tagBody += writeS32(i * 2 + 1) + bytes.fromhex("00 01 00 00 01 47 00 00")
		tagBody += writeS32(i * 2 + 2) + bytes.fromhex("00 01 00 00 01 47 00 00")

	#script init
	tagBody += bytes.fromhex("00 02 01 00 05")
	instruction  = bytes.fromhex("d0 30 60 01 30")
	if bytearray_flag:
		instruction += b"\x60" + writeS32(bytearray_index) + b"\x30"
		for i in [i for i in range(len(symbol_list)) if not isImage(path_list[i])]:
			instruction += genNewClassInstruction(i, name_offset, 2)
	if bytearray_flag and bitmap_flag:
		instruction += b"\x1d"
	if bitmap_flag:
		instruction += bytes.fromhex("60 02 30 60 03 30 60 04 30")
		for i in [i for i in range(len(symbol_list)) if isImage(path_list[i])]:
			instruction += genNewClassInstruction(i, name_offset, 4)
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
	if len(symbol_list) > 0:
		for i in range(len(symbol_list)):
			result += genAssetTag(i+1, path_list[i])
		result += genDoABC2Tag(symbol_list, path_list)
		result += genSymbolClassTag(symbol_list)
	result += bytes.fromhex("40 00 00 00")

	result = encodeLzmaSWF(result)
	with open(filePath + ".swf", "wb") as f:
		f.write(result)

	return "success."


if __name__ == "__main__":
	input(main(sys.argv[1]))