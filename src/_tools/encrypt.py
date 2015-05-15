import sys
import os

def main(filePath, code):
	if not os.path.exists(filePath):
		return "file not exist."
	if len(code) <= 0:
		return "code needed."
	
	code = [int(val) for val in code]
	
	with open(filePath, "rb") as f:
		fileData = f.read()
	
	fileData = bytearray(fileData)
	for i in range(17, len(fileData)):
		fileData[i] ^= code[i % len(code)]
	fileData = bytes(fileData)
	
	dotIndex = filePath.rfind(".")
	outputPath = filePath[:dotIndex] + "Encrypted" + filePath[dotIndex:]
	
	with open(outputPath, "wb") as f:
		f.write(fileData)
	
	return "success."

if __name__ == "__main__":
	input(main(sys.argv[1], sys.argv[2]))