from ByteArray import *

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
	return (None, -1)

def parse(fileData, fileName):
	global ba
	fileData, offset = decode(fileData)
	if offset < 0: return None, False
	ba = ByteArrayR(fileData)
	ba.position = offset + 32
	subMeshCount, boneCount, animationCount = [ba.readU16() for _ in range(3)]
	isAllSameBone = []
	subMeshList = [readSubMesh(isAllSameBone) for _ in range(subMeshCount)]
	animationList = [readAnimation() for _ in range(animationCount)]
	boneInfolist = [readBone(animationList, i) for i in range(boneCount)]
	boneCount = len([True for bone in boneInfolist if bone])

	isStaticMesh = (subMeshCount >= boneCount and animationCount == 1 and animationList[0] == 1 and all(isAllSameBone))
	#if isStaticMesh:
	#	print(os.path.relpath(fileName, file_folder), subMeshCount, boneCount)

	assert ba.position == len(fileData)
	return subMeshList, isStaticMesh

def readSubMesh(sameBoneInfoList):
	vetrexCount, normalCount, uvCount, triangleCount, subMeshIndex = [ba.readU16() for _ in range(5)]

	vertexList = [[[ba.readU16(), ba.readU16()][0], ba.readVector3()] for _ in range(vetrexCount)]
	ba.position += normalCount * 20
	ba.position += uvCount * 8
	
	prevBoneID = None
	isAllSameBone = True
	for _ in range(triangleCount):
		ba.position += 2
		vertexIndex = [ba.readU16() for _ in range(3)]
		ba.position += 16 + 40

		for index in vertexIndex:
			boneID = vertexList[index][0]
			if prevBoneID is None:
				prevBoneID = boneID
			elif prevBoneID != boneID:
				isAllSameBone = False
	sameBoneInfoList.append(isAllSameBone)
	return ba.readFixString(32)

def readAnimation():
	keyFrameCount = ba.readU16()
	if ba.readU8():
		ba.position += 12 * keyFrameCount
	return keyFrameCount

def readBone(animationList, boneID):
	if ba.readU8(): return
	ba.position += 34 + sum(animationList) * 24;
	return True

def readVector3List(count):
	return [ba.readVector3() for _ in range(count)]

import sys
import os
import re
import shutil
import os.path

def replaceExt(ext):
	ext = re.sub(r"\.ozj$", ".jpg", ext, 0, re.I)
	ext = re.sub(r"\.ozt$", ".tga", ext, 0, re.I)
	ext = re.sub(r"\.ozb$", ".bmp", ext, 0, re.I)
	return ext

def prepareDir(dirName):
	for entry in os.scandir(dirName):
		if entry.is_dir():
			prepareDir(entry.path)
			continue
		name, ext = os.path.splitext(entry.path)
		ext = ext.lower()
		if ext not in ('.ozj', '.ozt', '.ozb'):
			continue
		key = name + replaceExt(ext)
		if os.path.exists(key): continue
		with open(entry.path, "rb") as f:
			fileData = f.read()
		offset = 24 if key.endswith(".jpg") else 4
		fileData = fileData[offset:]
		with open(key, "wb") as f:
			f.write(fileData)
		
		
world_list = ["World1", "World10", "World11", "World12", "World19", "World2", "World25", "World3", "world31", "world32", "world34", "world35", "World38", "World39", "World4", "World40", "world41", "world42", "world43", "world47", "World5", "world52", "world55", "world56", "world57", "world58", "world59", "World6", "world63", "World64", "World65", "World66", "World67", "World68", "World69", "World7", "World70", "World71", "World72", "World73", "World74", "World75", "world78", "world79", "World8", "World80", "World9"]
object_list = [ "Object1", "Object10", "Object11", "Object12", "Object19", "Object2", "Object25", "Object3", "object31", "object32", "object34", "object35", "Object38", "Object39", "Object4", "Object40", "object41", "object42", "object43", "object47", "Object5", "object52", "object55", "object56", "object57", "object58", "object59", "object63", "Object64", "Object65", "Object66", "Object67", "Object68", "Object69", "Object7", "Object70", "Object71", "Object72", "Object73", "Object74", "Object75", "object78", "object79", "Object8", "Object80", "Object9"]

dir_list = ["Player", "Monster", "NPC", "Item", "Skill", "Effect", "Interface", "Logo"]
file_folder = ""
dest_folder = ""

def loadFile(path):
	with open(path, "rb") as f:
		return f.read()

def _findImage(folder, tex, dirList):
	result = []
	for dirName in dirList:
		srcFile = f"{file_folder}/{dirName}/{tex}"
		if os.path.exists(srcFile):
			result.append(srcFile)
	return result

def findImage(folder, tex):
	result = _findImage(folder, tex, dir_list)
	if len(result) == 0:
		result = _findImage(folder, tex, object_list)
	if len(result) > 0:
		return result[0]
	return []
	if len(result) == 1:
		return result[0]
	if len(result) == 2:
		a, b = [loadFile(path) for path in result]
		if a == b: return result[0]
	return [os.path.relpath(path, file_folder) for path in result]

def main():
	for folder in dir_list + object_list:
		for entry in os.scandir(f"{file_folder}/{folder}"):
			if entry.is_dir(): continue
			if not entry.name.lower().endswith(".bmd"): continue
			with open(entry.path, "rb") as f:
				texList, isStaticMesh = parse(f.read(), entry.path)
			if texList is None: continue
			if not os.path.exists(f"{dest_folder}/{folder}"):
				os.mkdir(f"{dest_folder}/{folder}")
			if not os.path.exists(f"{dest_folder}/{folder}/{entry.name}"):
				if isStaticMesh:
					with open(entry.path, "rb") as f:
						data = bytearray(f.read())
					with open(f"{dest_folder}/{folder}/{entry.name}", "wb") as f:
						data[2] = ord('S')
						f.write(data)
						print(entry.path)
				else:
					shutil.copy(entry.path, f"{dest_folder}/{folder}")
			continue
			for tex in texList:
				name, ext = os.path.splitext(tex)
				ext = ext.lower()
				tex = name + ext
				
				srcFile = f"{file_folder}/{folder}/{tex}"
				dstFile = f"{dest_folder}/{folder}/{tex}"
				if not os.path.exists(srcFile):
					srcFile = findImage(folder, tex)
					if not isinstance(srcFile, str):
						print(os.path.relpath(entry.path, file_folder), tex, "[" + ", ".join(srcFile) + "]")
						continue
				if os.path.exists(dstFile): continue
				shutil.copy(srcFile, dstFile)
				

if __name__ == "__main__":
	#prepareDir(file_folder)
	main()