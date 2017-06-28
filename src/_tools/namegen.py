import time
import random

__all__ = ["mix"]

var0 = [
"$","_",
"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"
]

var = var0 + ["0","1","2","3","4","5","6","7","8","9"]

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
		if not ("/" in name or ":" in name):
			mixDict[name] = gen(name, excludeSet)
	for name in mixSet:
		if ("/" in name or ":" in name):
			mixDict[name] = compose(name, mixDict)
	for name in mixSet:
		mixDict[name] = mixDict[name].encode()
	return mixDict

def compose(name, mixDict):
	if name in mixDict:
		return mixDict[name]
	if "/" in name:
		return "/".join(compose(item, mixDict)  for item in name.split("/"))
	if ":" in name:
		return ":".join(mixDict.get(item, item) for item in name.split(":"))
	return name
