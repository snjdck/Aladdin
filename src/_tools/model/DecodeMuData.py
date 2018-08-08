import sys
import os
import re
import shutil
import os.path

xor_code = (0xfc, 0xcf, 0xab)
input_path = r""
output_path = ""

def decodeFile(path):
	with open(path, "rb") as f:
		fileData = bytearray(f.read())
	for i in range(len(fileData)):
		fileData[i] ^= xor_code[i % len(xor_code)]
	return fileData

def main(dirName):
	for entry in os.scandir(dirName):
		if entry.is_dir():
			main(entry.path)
			continue
		name, ext = os.path.splitext(entry.path)
		ext = ext.lower()
		if ext != '.bmd':
			continue
		with open(entry.path, "rb") as f:
			fileData = f.read(3)
		if fileData == b"BMD":
			continue
		fileData = decodeFile(entry.path)
		with open(f"{output_path}/{entry.name}", "wb") as f:
			f.write(fileData)

if __name__ == "__main__":
	main(input_path)