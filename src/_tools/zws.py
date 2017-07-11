import struct
import sys
import os

from swf_tag import encodeTag, genImageTag
from instruction import optimize
from swf import *
from SwfTagType import *

tagList = []

def removeTags(rawData, offset, tagType, tagHeadSize, tagBodySize):
	tagType = SwfTagType(tagType)
	if tagType in (SwfTagType.ProductInfo, SwfTagType.FrameLabel, SwfTagType.ScriptLimits, SwfTagType.Metadata):
		return
	#hasMetadata = false
	if tagType == SwfTagType.FileAttributes:
		tagBody = readUI32(rawData, offset+2)
		tagBody &= 0xEF
		tagList.append(rawData[offset:offset+2] + struct.pack("I", tagBody))
	elif tagType == SwfTagType.DefineBitsJPEG2:
		assetID = readUI16(rawData, offset+tagHeadSize)
		imageData = rawData[offset+tagHeadSize+2:offset+tagHeadSize+tagBodySize]
		tagList.append(genImageTag(assetID, imageData))
	elif tagType == SwfTagType.DoABC2:
		tagBody = rawData[offset+tagHeadSize:offset+tagHeadSize+tagBodySize]
		tagList.append(encodeTag(tagType.value, optimize(tagBody)))
	else:
		tagList.append(rawData[offset:offset+tagHeadSize+tagBodySize])

def main(filePath):
	if not os.path.exists(filePath):
		return "file not exist."

	with open(filePath, "rb") as f:
		fileData = f.read()

	sign, version, _ = decodeHead(fileData)

	rawData = decodeBody(fileData)

	if not rawData:
		return "invalid swf file."
	
	offset = visitTags(rawData, removeTags)
	rawData = rawData[:offset]
	for chunk in tagList:
		rawData += chunk

	dotIndex = filePath.rfind(".")
	outputPath = filePath[:dotIndex] + "Compressed" + filePath[dotIndex:]
	
	with open(outputPath, "wb") as f:
		f.write(encodeLzmaSWF(rawData, version))
	
	return "success."

if __name__ == "__main__":
	input(main(sys.argv[1]))