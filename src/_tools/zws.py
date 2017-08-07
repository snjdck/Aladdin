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
	offset += tagHeadSize
	if tagType == SwfTagType.FileAttributes:
		tagBody = int.from_bytes(rawData[offset:offset+4], "little")
		tagBody &= ~0x10#hasMetadata = false
		tagList.append(encodeTag(tagType.value, tagBody.to_bytes(4, "little")))
	elif tagType == SwfTagType.DefineBitsJPEG2:
		assetID = int.from_bytes(rawData[offset:offset+2], "little")
		imageData = rawData[offset+2:offset+tagBodySize]
		tagList.append(genImageTag(assetID, imageData))
	elif tagType == SwfTagType.DoABC2:
		tagBody = rawData[offset:offset+tagBodySize]
		tagList.append(encodeTag(tagType.value, optimize(tagBody)))
	else:
		tagList.append(rawData[offset-tagHeadSize:offset+tagBodySize])

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