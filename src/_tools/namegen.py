import time
import random
import string
import re

__all__ = ["mix", "FilePrivateNS", "AS_FILE"]

FilePrivateNS = "FilePrivateNS:"
AS_FILE = re.compile(r"(\w+)\.as\$\d+$")

var0 = "$_" + string.ascii_letters
var  = var0 + string.digits

def gen(name, excludeSet):
	nChar = len(name.encode())
	assert nChar > 0
	timestamp = time.time()
	while True:
		result = random.choice(var0)
		while len(result) < nChar:
			result += random.choice(var)
		if result not in excludeSet:
			excludeSet.add(result)
			return result
		if time.time() - timestamp > 1:
			print("failed", name)
			return name

def mix(mixSet, excludeSet):
	mixDict = {}
	for name in mixSet:
		if not needCompose(name):
			mixDict[name] = gen(name, excludeSet)
	for name in mixSet:
		if needCompose(name):
			mixDict[name] = compose(name, mixDict)
	for name in mixSet:
		mixDict[name] = mixDict[name].encode()
	return mixDict

def needCompose(name):
	return "/" in name or ":" in name or AS_FILE.match(name)

def compose(name, mixDict):
	if name in mixDict:
		return mixDict[name]
	if "/" in name:
		return "/".join(compose(item, mixDict)  for item in name.split("/"))
	if ":" in name:
		return ":".join(mixDict.get(item, item) for item in name.split(":"))
	m = AS_FILE.match(name)
	if m: return compose(m.group(1), mixDict) + name[m.end(1):]
	return name
