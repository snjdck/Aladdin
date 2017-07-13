import struct
import json

def readFile(path):
	with open(f"{path}.fbx", "rb") as f:
		return f.read()

def inBinaryFile(data):
	return data.startswith(b"Kaydara FBX Binary  \x00\x1A\x00")

def readInt():
	global offset
	value = struct.unpack_from("<I", data, offset)[0]
	offset += 4
	return value

def readByte():
	global offset
	value = data[offset]
	offset += 1
	return value

def readString(size):
	return readBytes(size).decode()

def readBytes(size):
	global offset
	value = data[offset:offset+size]
	offset += size
	return value

def readProperty():
	global offset
	typeCode = readString(1)
	if typeCode == "D":
		value = struct.unpack_from("<d", data, offset)[0]
		offset += 8
		return value
	if typeCode == "F":
		value = struct.unpack_from("<f", data, offset)[0]
		offset += 4
		return value
	if typeCode == "I":
		value = struct.unpack_from("<i", data, offset)[0]
		offset += 4
		return value
	if typeCode == "Y":
		value = struct.unpack_from("<h", data, offset)[0]
		offset += 2
		return value
	if typeCode == "L":
		value = struct.unpack_from("<q", data, offset)[0]
		offset += 8
		return value
	if typeCode == "C": return readByte() != 0
	if typeCode == "S": return readString(readInt())
	if typeCode == "R": return readBytes(readInt())
	assert False, typeCode

def readTagList(endOffset):
	global offset
	tagList = []
	while offset < endOffset:
		if data[offset:offset+len(zeroTag)] == zeroTag:
			offset += len(zeroTag)
			break
		tagList.append(readTag())
	return tagList

def readTag():
	endOffset = readInt()
	numProperties = readInt()
	propertyListLen = readInt()
	tagName = readString(readByte())
	end = offset + propertyListLen
	propList = [readProperty() for _ in range(numProperties)]
		
	assert offset == end
	subTags = readTagList(endOffset)
	assert offset == endOffset
	return tagName, propList, subTags


data = readFile("humanoid")
offset = 23
zeroTag = bytes(13)
readInt()
excludeTagNames = ("FBXHeaderExtension", "FileId", "CreationTime", "Creator", "ObjectData", "Version5", "Definitions", "Relations", "Connections", "HierarchyView")
tagList = readTagList(len(data))
tagList = [tag for tag in tagList if tag[0] not in excludeTagNames]
for tag in tagList:
	print(tag[:2])
for tag in tagList[0][2]:
	if not (tag[0] == "Model" and tag[1][1] == "Mesh"):
		continue
	#if tag[0] in ("Deformer", "Folder", "GlobalShading", "Device", "Constraint", "Material"): continue
	#if tag[1][1] in ("Light", "Camera", "LimbNode", "Mesh"): continue

	for item in tag[2]:
		if item[0] == "Vertices":
			vertexList = item[1]
			continue
		if item[0] == "PolygonVertexIndex":
			indexList = item[1]
			continue
		if item[0] == "Shape":
			#print(item)
			continue
		if item[0] == "LayerElementNormal":
			continue
	print(len(vertexList) / 3, max(indexList))
input(len(tagList))