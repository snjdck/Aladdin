import re
import math
from ByteArray import *

VertexFormatPattern = re.compile("(u?[bsi]|[fh])([1234])")
MethodDict = {"f":"writeF32", "h":"writeF16", "b":"writeS8", "s":"writeS16", "i":"writeS32", "ub":"writeU8", "us":"writeU16", "ui":"writeU32"}

__all__ = ("create", "VertexFormat", "SubMesh", "Bone", "Animation", "KeyFrame")

def encodeList(targetList, output, *userData):
	output.writeU16(len(targetList))
	for target in targetList:
		target.encode(output, *userData)

class VertexFormat:
	__slots__ = ("name", "format", "offset")
	def __init__(self, name, format, offset):
		self.name = name
		self.format = format
		self.offset = offset

	def encode(self, output):
		output.writeString1(self.name)
		output.writeString1(self.format)
		output.writeU8(self.offset)

	def writeVertex(self, vertexData, offset, output):
		match = VertexFormatPattern.fullmatch(self.format)
		count = int(match[2])
		method = getattr(output, MethodDict[match[1]])
		for i in range(count):
			method(vertexData[offset+i]);

	def valueCount(self):
		match = VertexFormatPattern.fullmatch(self.format)
		return int(match[2])

	def typeSize(self):
		match = VertexFormatPattern.fullmatch(self.format)
		if re.search("[if]$", match[1]): return 4
		if re.search("[sh]$", match[1]): return 2
		if re.search("b$",    match[1]): return 1

	def byteSize(self):
		match = VertexFormatPattern.fullmatch(self.format)
		count = int(match[2])
		if re.search("[if]$", match[1]): return count << 2
		if re.search("[sh]$", match[1]): return count << 1
		if re.search("b$",    match[1]): return count

class SubMesh:
	__slots__ = ("texture", "vertexData", "indexData", "boneData")
	def __init__(self):
		self.boneData = []
		self.texture = ""

	def encode(self, output, vertexFormatList):
		assert len(self.indexData) < 0xF0000
		assert len(self.indexData) % 3 == 0

		byteSizePerVertex = sum(vertexFormat.byteSize() for vertexFormat in vertexFormatList)
		maxTypeSize = max(vertexFormat.typeSize() for vertexFormat in vertexFormatList)
		byteSizePerVertex = math.ceil(byteSizePerVertex / maxTypeSize) * maxTypeSize
		valueCountPerVertex = sum(vertexFormat.valueCount() for vertexFormat in vertexFormatList)
		vertexCount = len(self.vertexData) // valueCountPerVertex

		output.writeString1(self.texture)
		output.writeU16(vertexCount)
		output.writeU8(byteSizePerVertex)
		for i in range(vertexCount):
			offset = i * valueCountPerVertex
			byteSize = 0
			for vertexFormat in vertexFormatList:
				vertexFormat.writeVertex(self.vertexData, offset, output);
				offset += vertexFormat.valueCount()
				byteSize += vertexFormat.byteSize()
			while byteSize < byteSizePerVertex:
				output.writeU8(0)
				byteSize += 1
		output.writeU32(len(self.indexData))
		for value in self.indexData:
			output.writeU16(value)
		output.writeU8(len(self.boneData))
		for value in self.boneData:
			output.writeU8(value)

class Bone:
	__slots__ = ("name", "id", "pid")
	def __init__(self, name, id, pid):
		self.name = name
		self.id = id
		self.pid = pid

	def encode(self, output):
		output.writeString1(self.name)
		output.writeS16(self.id)
		output.writeS16(self.pid)

class Animation:
	__slots__ = ("name", "duration", "trackDict")
	def __init__(self, name, duration):
		self.name = name
		self.duration = duration
		self.trackDict = {}

	def addTrack(self, boneID, keyFrameList):
		self.trackDict[boneID] = keyFrameList

	def encode(self, output):
		output.writeString1(self.name)
		output.writeF32(self.duration)
		output.writeU16(len(self.trackDict))
		for boneID, keyFrameList in self.trackDict.items():
			output.writeU16(boneID)
			encodeList(keyFrameList, output)

class KeyFrame:
	__slots__ = ("time", "translation", "rotation")
	def __init__(self, time, translation, rotation):
		self.time = time
		self.translation = translation
		self.rotation = rotation

	def encode(self, output):
		output.writeF32(self.time)
		for i in range(3): output.writeF32(self.translation[i])
		for i in range(3): output.writeF32(self.rotation[i])

def create(vertexFormatList, subMeshList, boneList=[], animationList=[]):
	ba = ByteArrayW()
	encodeList(vertexFormatList, ba)
	encodeList(subMeshList, ba, vertexFormatList)
	encodeList(boneList, ba)
	encodeList(animationList, ba)
	with open("test.mesh", "wb") as f:
		f.write(ba.rawData)
"""
def addSubMesh(subMesh):
	assert len(subMesh.vertexData) == subMesh.vertexCount * subMesh.data32PerVertex
	assert subMesh.vertexCount <= 0xFFFF
	assert subMesh.data32PerVertex <= 64
	assert len(subMesh.indexData) < 0xF0000
	assert len(subMesh.indexData) % 3 == 0

	writeStr(subMesh.texture)
	writeU16(subMesh.vertexCount)
	writeU8(subMesh.data32PerVertex)
	for value in subMesh.vertexData:
		writeFloat(value)
	writeU32(len(subMesh.indexData))
	for value in subMesh.indexData:
		writeU16(value)

def addBone(bone):
	writeStr(bone.name)
	writeS16(bone.id)
	writeS16(bone.pid)

def addAnimation(animation):
	writeStr(animation.name)
	writeFloat(animation.duration)
	writeU16(len(animation.trackList))
	for track in animation.trackList:
		addTrack(track)

def addTrack(track):
	writeU16(state.boneID)
	writeU16(len(track.keyFrameList))
	for keyFrame in track.keyFrameList:
		writeFloat(keyFrame.time)
		for i in range(3):
			writeFloat(keyFrame.translation[i])
		for i in range(3):
			writeFloat(keyFrame.rotation[i])
"""
