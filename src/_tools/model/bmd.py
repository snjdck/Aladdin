from ByteArray import *
from model import *

__all__ = ["parse"]

keyList = (0xd1, 0x73, 0x52, 0xf6, 0xd2, 0x9a, 0xcb, 0x27, 0x3e, 0xaf, 0x59, 0x31, 0x37, 0xb3, 0xe7, 0xa2)

def decode(fileData):
	if fileData[3] == 0x0A:
		return fileData, 4
	if fileData[3] == 0x0C:
		memory = bytearray(fileData)
		offset = 0x5E
		for i in range(8, len(fileData)):
			value = fileData[i]
			index = (i - 8) % len(keyList)
			memory[i] = 0xFF & ((value ^ keyList[index]) - offset)
			offset    = 0xFF & (value + 0x3D)
		return bytes(memory), 8

def parse(fileData):
	global ba
	fileData, offset = decode(fileData)
	ba = ByteArrayR(fileData)
	ba.position = offset
	ba.readFixString(32)
	subMeshCount, boneCount, animationCount = [ba.readU16() for _ in range(3)]
	subMeshList = [readSubMesh() for _ in range(subMeshCount)]
	animationList = [readAnimation() for _ in range(animationCount)]
	boneInfolist = [readBone(animationList, i) for i in range(boneCount)]
	boneInfolist = [info for info in boneInfolist if info is not None]
	boneList = [bone for bone, animation in boneInfolist]
	for i in range(len(animationList)):
		animation = Animation(str(i), animationList[i])
		for bone, boneAnimationList in boneInfolist:
			animation.addTrack(bone.id, boneAnimationList[i])
		animationList[i] = animation

	assert ba.position == len(fileData)
	print(subMeshCount, boneCount, animationCount)
	print(animationList)
	vertexFormatList = [
		VertexFormat("position", "f3", 0),
		VertexFormat("normal", "f3", 12),
		VertexFormat("uv", "f2", 24),
		VertexFormat("boneIndex", "us1", 32)
	]
	create(vertexFormatList, subMeshList, boneList, animationList)
	#print(bound.minX, bound.minY, bound.minZ, bound.maxX, bound.maxY, bound.maxZ)

def readSubMesh():
	vetrexCount, normalCount, uvCount, triangleCount, subMeshIndex = [ba.readU16() for _ in range(5)]

	vertexList = [[[ba.readU16(), ba.readU16()][0], ba.readVector3()] for _ in range(vetrexCount)]
	normalList = [[ba.readU32(), ba.readVector3(), ba.readU32()][1] for _ in range(normalCount)]
	uvList = [ba.readVector2() for _ in range(uvCount)]

	vertexData = []
	boneData = []
	indexData = list(range(triangleCount * 3))
	
	for _ in range(triangleCount):
		ba.readU16()
		vertexIndex = [ba.readU16() for _ in range(3)]
		ba.readU16()
		normalIndex = [ba.readU16() for _ in range(3)]
		ba.readU16()
		uvIndex = [ba.readU16() for _ in range(3)]
		ba.position += 40

		for i in range(3):
			vertexInfo = vertexList[vertexIndex[i]]
			boneId = vertexInfo[0]
			if boneId not in boneData:
				boneData.append(boneId)
			vertexData += vertexInfo[1] + normalList[normalIndex[i]] + uvList[uvIndex[i]] + [boneData.index(boneId) << 1]

	textureName = ba.readFixString(32)
	subMesh = SubMesh()
	subMesh.vertexData = vertexData
	subMesh.boneData = boneData
	subMesh.indexData = indexData
	subMesh.texture = textureName
	print(boneData)
	return subMesh

def readAnimation():
	keyFrameCount = ba.readU16()
	if ba.readU8():
		ba.position += 12 * keyFrameCount
	return keyFrameCount

def readBone(animationList, boneId):
	if ba.readU8(): return
	bone = Bone(ba.readFixString(32), boneId, ba.readS16())
	animationList = [zip(range(keyFrameCount), readVector3List(keyFrameCount), readVector3List(keyFrameCount)) for keyFrameCount in animationList]
	return bone, [[KeyFrame(*info) for info in animation] for animation in animationList]

def readVector3List(count):
	return [ba.readVector3() for _ in range(count)]

if __name__ == "__main__":
	with open("Spear10.bmd", "rb") as f:
		parse(f.read())
	input()