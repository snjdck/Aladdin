from base64 import b64encode, b64decode

THUNDER  = "thunder://"
FLASHGET = "flashget://"
QQDL     = "qqdl://"

def encode(path):
	path = "AA" + path + "ZZ"
	return THUNDER + b64encode(path.encode()).decode()

def decode(path, code="utf-8"):
	offset = path.index("://") + 3
	url = b64decode(path[offset:]).decode(code)
	if path.startswith(THUNDER):
		return url[2:-2]
	if path.startswith(FLASHGET):
		return url[10:-10]
	if path.startswith(QQDL):
		return url

if __name__ == "__main__":
	print(decode("thunder://QUFodHRwOi8vZGwxMjAuODBzLmltOjkyMC8xNzA1L8n51q7Qzi/J+dau0M4ubXA0Wlo=", "gb2312"))
	input()