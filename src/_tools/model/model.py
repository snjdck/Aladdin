import struct
from ByteArray import *

ba = ByteArrayW()

def writeU8(value): ba.writeU8(value)
def writeU16(value): ba.writeU16(value)
def writeU32(value): ba.writeU32(value)
def writeFloat(value): ba.writeF32(value)
def writeS16(value): ba.writeS16(value)
def writeStr(value):
	value = value.encode()
	ba.writeU8(len(value))
	ba.rawData += value

class SubMesh:
	__slots__ = ("vertexCount", "data32PerVertex", "texture", "vertexData", "indexData")

	def __init__(self):
		self.texture = ""

class VertexFormat:
	__slots__ = ("name", "format", "offset")
	def __init__(self, name, format, offset):
		self.name = name
		self.format = format
		self.offset = offset


class Bone:
	__slots__ = ("id", "name", "pid")

class Animation:
	__slots__ = ("name", "duration", "keyFrameList")

def create(vertexFormatList, subMeshList, boneList=[], animationList=[]):
	writeU8(len(vertexFormatList))
	for vertexFormat in vertexFormatList:
		writeStr(vertexFormat.name)
		writeStr(vertexFormat.format)
		writeU8(vertexFormat.offset)

	writeU16(len(subMeshList))
	for subMesh in subMeshList:
		addSubMesh(subMesh)

	writeU16(len(boneList))
	for bone in boneList:
		addBone(bone)

	writeU16(len(animationList))
	for animation in animationList:
		addAnimation(animation)

	with open("test.mesh", "wb") as f:
		f.write(ba.rawData)

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

if __name__ == "__main__":
	subMesh = SubMesh()
	subMesh.vertexCount = 3
	subMesh.data32PerVertex = 3
	subMesh.vertexData = (-1, -1, 0, 0, 1, 0, 1, -1, 0)
	subMesh.indexData = (0, 1, 2)
	create([VertexFormat("position", "float3", 0)], [subMesh])

	input()