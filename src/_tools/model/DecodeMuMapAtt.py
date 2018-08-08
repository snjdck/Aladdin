import sys
import os
import re
import shutil
import os.path
import struct

input_path = ""

"""
NotWalk = 4
Walk = 0
Safe = 1
Wall = 5
Hole = 12
Hole2 = 8
Hole3 = 13,	
Unknown = 2,
BCBridgeStart = 36,
BCBridgeMiddle = 32,
BCBridgeFinish = 40

"TileGrass01", "TileGrass02", "TileGround01", "TileGround02", "TileGround03", "TileWater01", "TileWood01", "TileRock01", "TileRock02"
"""

def readPic(fileData, offset):
	result = []
	for i in range(256):
		for j in range(256):
			result.append(fileData[offset+i*256+j])
	return result

def decodeAtt(path):
	with open(path, "rb") as f:
		fileData = f.read()
	assert len(fileData) == 65536 + 3
	print(set(readPic(fileData, 3)))

def decodeMap(path):
	with open(path, "rb") as f:
		fileData = f.read()
	assert len(fileData) == 65536 * 3 + 1
	for i in range(3):
		print(set(readPic(fileData, 1+65536*i)))

def decodeObj(path):
	with open(path, "rb") as f:
		fileData = f.read()
	count = struct.unpack_from("<H", fileData, 1)[0]
	assert len(fileData) == 30 * count + 3
	for i in range(count):
		info = struct.unpack_from("<H7f", fileData, 3 + i * 30)


if __name__ == "__main__":
	decodeAtt(input_path + "Terrain.att")
	decodeMap(input_path + "Terrain.map")
	decodeObj(input_path + "Terrain.obj")