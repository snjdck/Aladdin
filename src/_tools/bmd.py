import struct
import sys
from fbx import *

class Bound:
	def __init__(self):
		self.minX = sys.maxsize
		self.minY = sys.maxsize
		self.minZ = sys.maxsize
		self.maxX = -sys.maxsize
		self.maxY = -sys.maxsize
		self.maxZ = -sys.maxsize

	def addPt(self, pt):
		if pt[0] < self.minX: self.minX = pt[0]
		if pt[0] > self.maxX: self.maxX = pt[0]
		if pt[1] < self.minY: self.minY = pt[1]
		if pt[1] > self.maxY: self.maxY = pt[1]
		if pt[2] < self.minZ: self.minZ = pt[2]
		if pt[2] > self.maxZ: self.maxZ = pt[2]


keyList = (0xd1, 0x73, 0x52, 0xf6, 0xd2, 0x9a, 0xcb, 0x27, 0x3e, 0xaf, 0x59, 0x31, 0x37, 0xb3, 0xe7, 0xa2)

def readUI16(rawData, offset):
	return struct.unpack_from("H", rawData, offset)[0]

def readI16(rawData, offset):
	return struct.unpack_from("h", rawData, offset)[0]

def readUI32(rawData, offset):
	return struct.unpack_from("I", rawData, offset)[0]

def readFixStr(fileData, offset):
	if fileData[offset] == 0:
		return ""
	start = offset
	while fileData[offset] != 0:
		offset += 1
	return fileData[start:offset].decode("gb2312")

def parse(fileData, fbxMgr):
	fileData, offset = decode(fileData)
	readFixStr(fileData, offset)
	offset += 32
	subMeshCount, boneCount, animationCount = struct.unpack_from("3H", fileData, offset)
	offset += 6
	animationList = []
	bound = Bound()
	for i in range(subMeshCount):
		subMesh = fbxMgr.createMesh(str(i))
		offset = readSubMesh(fileData, offset, subMesh, bound)
	for _ in range(animationCount):
		keyFrameCount, offset = readAnimation(fileData, offset)
		animationList.append(keyFrameCount)
	for i in range(boneCount):
		bone, offset = readBone(fileData, offset, animationList, i)
	assert offset == len(fileData)
	print(subMeshCount, boneCount, animationCount)
	print(animationList)
	print(bound.minX, bound.minY, bound.minZ, bound.maxX, bound.maxY, bound.maxZ)

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

def readSubMesh(fileData, offset, pMesh, bound):
	vetrexCount, normalCount, uvCount, triangleCount, subMeshIndex = struct.unpack_from("5H", fileData, offset)
	offset += 10

	pMesh.InitControlPoints(vetrexCount)

	for i in range(vetrexCount):
		vertex = struct.unpack_from("2H3f", fileData, offset)
		print(vertex)
		bound.addPt(vertex[2:])
		pMesh.SetControlPointAt(FbxVector4(*vertex[2:]), i)
		offset += 16

	for i in range(normalCount):
		normal = struct.unpack_from("3f", fileData, offset+4)
		offset += 20

	for i in range(uvCount):
		uv = struct.unpack_from("2f", fileData, offset)
		offset += 8
	
	for i in range(triangleCount):
		vertexIndex = struct.unpack_from("3H", fileData, offset+2)
		normalIndex = struct.unpack_from("3H", fileData, offset+10)
		uvIndex = struct.unpack_from("3H", fileData, offset+18)
		offset += 64

		pMesh.BeginPolygon()
		for index in vertexIndex:
			pMesh.AddPolygon(index)
		pMesh.EndPolygon()

	textureName = readFixStr(fileData, offset)
	print(textureName)
	offset += 32

	return offset

def readAnimation(fileData, offset):
	keyFrameCount = readUI16(fileData, offset)
	offset += 2
	hasOffsetData = fileData[offset] > 0
	offset += 1
	if hasOffsetData:
		offset += 12 * keyFrameCount
	return keyFrameCount, offset

def readBone(fileData, offset, animationList, boneId):
	noBoneFlag = fileData[offset] > 0
	offset += 1

	if noBoneFlag:
		return None, offset

	boneName = readFixStr(fileData, offset)
	offset += 32
	parentBoneId = readI16(fileData, offset)
	offset += 2
	for i in range(len(animationList)):
		for j in range(animationList[i]):
			offset += 24

	return (boneId, boneName, parentBoneId), offset