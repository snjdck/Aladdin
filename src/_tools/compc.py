import subprocess
import os
import sys
import string

TaskList = [
	('LibCommon',		[]),
	('Agalc',			['LibCommon']),
	('ScriptEngine',	['LibCommon']),
	('LibReflection',	['LibCommon']),
	('LibSignal',		['LibCommon']),
	('LibHttp',			['LibCommon']),
	('Lib3D',			['LibCommon','Agalc']),
	('LibSocket',		['LibCommon','LibSignal']),
	('LibInjector',		['LibCommon','LibReflection']),
	('LibMvc',			['LibCommon','LibInjector']),
	('Lib2D',			['LibCommon','LibSignal']),
	('LibStd',			['LibCommon','Lib2D']),
	('LibUI',			['LibCommon','Lib2D']),
	('LibAI',			['LibCommon','LibStd']),
	('EntityEngine',	['LibCommon','LibSignal','LibMvc','LibStd'])
]

FlexConfig = {
	"sdkPath"		: r'"C:\Program Files (x86)\Adobe\Adobe Flash Builder 4.6\sdks\4.6.0\bin\compc.exe" ',
	"mxLib"		: r'"C:\Program Files (x86)\Adobe\Adobe Flash Builder 4.6\sdks\4.6.0\frameworks\libs\framework.swc"',
#	"mxLib2"		: r'"C:\Program Files (x86)\Adobe\Adobe Flash Builder 4.6\sdks\4.6.0\frameworks\libs\mx\mx.swc"',
	"sourceRoot"	: "E:\\flashWorkspace\\Aladdin\\src\\"
}

PLAYER_VERSION = (
	"1.0.0", "2.0.0", "3.0.0", "4.0.0", "5.0.0",
	"6.0.0", "7.0.0", "8.0.0", "9.0.0", "10.0.0",
	"10.2.0","10.3.0","11.0.0","11.1.0","11.2.0",
	"11.3.0","11.4.0","11.5.0","11.6.0","11.7.0",
	"11.8.0","11.9.0","12.0.0","13.0.0","14.0.0",
	"15.0.0","16.0.0","17.0.0","18.0.0"
)

class Item:
	def __init__(self, name, ref):
		self.name = name
		self.ref = ref

	@staticmethod
	def getArgs(sourcePath, outputPath, swfVersion=11):
		args = [
			"-output=" + outputPath,
			"-compiler.source-path=" + sourcePath,
			"-include-sources=" + sourcePath,
			"-swf-version=" + str(swfVersion),
			"-target-player=" + PLAYER_VERSION[swfVersion-1],
			"-optimize=true",
			"-debug=false",
			"-library-path=" + FlexConfig['mxLib'],
			"-accessible=false"
		]
		return string.join(args, " ")

	def getSourcePath(self):
		return FlexConfig["sourceRoot"] + self.name

	def getOutputPath(self, name):
		return FlexConfig["sourceRoot"] + "$tools\\swcs\\" + name + '.swc'
	
	def getFilePath(self):
		result = self.getArgs(self.getSourcePath(), self.getOutputPath(self.name), 17)
		if not self.ref:
			return result
		for libName in self.ref:
#			result += " -include-libraries=" + self.getOutputPath(libName)
			result += " -library-path=" + self.getOutputPath(libName)
		return result

logFile = open(FlexConfig["sourceRoot"] + "$tools\\log.txt", "w+")
TaskList = [Item(libItem[0], libItem[1]) for libItem in TaskList]

def clearFile():
	for libItem in TaskList:
		fileName = libItem.getOutputPath(libItem.name)
		if os.path.isfile(fileName):
			os.remove(fileName)

def compileFile():
	for libItem in TaskList:
		childProcess = subprocess.Popen(
			FlexConfig["sdkPath"] + libItem.getFilePath(),
			stdout=logFile,
			stderr=logFile
		)
		if childProcess.wait() != 0:
			errorFiles.append(libItem.name)
		else:
			print(libItem.name + " is ok!")
	else:
		print("===compile complete!")

errorFiles = []
clearFile()
compileFile()
print("error files:\n");
for errorFile in errorFiles:
	print(errorFile + "\n")
raw_input()