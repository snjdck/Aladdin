from base64 import b64encode, b64decode

def encode(path):
	path = "AA" + path + "ZZ"
	return "thunder://" + b64encode(path.encode()).decode()

def decode(path):
	offset = path.index("://") + 3
	url = b64decode(path[offset:]).decode()
	if path.startswith("thunder://"):
		return url[2:-2]
	if path.startswith("flashget://"):
		return url[10:-10]
	if path.startswith("qqdl://"):
		return url


if __name__ == "__main__":
	print(decode("thunder://QUFodHRwOi8vdG9vbC5sdS90ZXN0LnppcFpa"))
	print(decode("flashget://W0ZMQVNIR0VUXWh0dHA6Ly90b29sLmx1L3Rlc3QuemlwW0ZMQVNIR0VUXQ=="))
	print(decode("qqdl://aHR0cDovL3Rvb2wubHUvdGVzdC56aXA="))
	print(encode("http://tool.lu/test.zip"))
	input()