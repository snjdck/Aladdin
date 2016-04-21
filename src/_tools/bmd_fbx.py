import sys
import os
import struct
import bmd
import FbxCommon
from fbx import *

lSampleFileName = "__test.Fbx"


class FbxMgr:
	def __init__(self, mgr, scene):
		self.mgr = mgr
		self.scene = scene

	def createMesh(self, name):
		mesh = FbxMesh.Create(lSdkManager, name)
		node = FbxNode.Create(self.mgr, name)
		node.SetNodeAttribute(mesh)
		node.SetShadingMode(FbxNode.eTextureShading)
		self.scene.GetRootNode().AddChild(node)
		return mesh

if __name__ == "__main__":
	lSdkManager, lScene = FbxCommon.InitializeSdkObjects()

	with open("MuDemo/Axe01.bmd", "rb") as f:
		fileData = f.read()

	fbxMgr = FbxMgr(lSdkManager, lScene)
	bmd.parse(fileData, fbxMgr)

	lResult = FbxCommon.SaveScene(lSdkManager, lScene, lSampleFileName)
	input("pause")

	if lResult == False:
		print("\n\nAn error occurred while saving the scene...\n")
		lSdkManager.Destroy()
		sys.exit(1)

	lSdkManager.Destroy()
	sys.exit(0)