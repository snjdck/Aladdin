from ByteArray import *

__all__ = ("create", "VertexFormat", "SubMesh", "Bone", "Animation", "KeyFrame")

def encodeList(targetList, output):
	output.writeU16(len(targetList))
	for target in targetList:
		target.encode(output)

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

class SubMesh:
	__slots__ = ("vertexCount", "data32PerVertex", "texture", "vertexData", "indexData")
	def __init__(self):
		self.texture = ""

	def encode(self, output):
		assert len(self.vertexData) == self.vertexCount * self.data32PerVertex
		assert self.vertexCount <= 0xFFFF
		assert self.data32PerVertex <= 64
		assert len(self.indexData) < 0xF0000
		assert len(self.indexData) % 3 == 0

		output.writeString1(self.texture)
		output.writeU16(self.vertexCount)
		output.writeU8(self.data32PerVertex)
		for value in self.vertexData:
			output.writeF32(value)
		output.writeU32(len(self.indexData))
		for value in self.indexData:
			output.writeU16(value)

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
	encodeList(subMeshList, ba)
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
if __name__ == "__main__":
	subMesh = SubMesh()
	subMesh.vertexCount = 3
	subMesh.data32PerVertex = 3
	subMesh.vertexData = (-1, -1, 0, 0, 1, 0, 1, -1, 0)
	subMesh.indexData = (0, 1, 2)
	create([VertexFormat("position", "float3", 0)], [subMesh])

	input()