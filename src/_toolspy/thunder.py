from base64 import b64encode, b64decode

codec = ("utf-8", "gb2312")

THUNDER  = "thunder://"
FLASHGET = "flashget://"
QQDL     = "qqdl://"

def encode(path):
	path = "AA" + path + "ZZ"
	return THUNDER + b64encode(path.encode()).decode()

def decode(path):
	offset = path.index("://") + 3
	url = b64decode(path[offset:])
	for code in codec:
		try:
			url = url.decode(code)
			break
		except UnicodeDecodeError as error:
			pass
	else: return
	if path.startswith(THUNDER):
		return url[2:-2]
	if path.startswith(FLASHGET):
		return url[10:-10]
	if path.startswith(QQDL):
		return url

if __name__ == "__main__":
	print(decode("thunder://QUFodHRwOi8vZGwxMjAuODBzLmltOjkyMC8xNzA1L8n51q7Qzi/J+dau0M4ubXA0Wlo="))
	print(decode("thunder://QUFlZDJrOi8vfGZpbGV8ztLKx8TjtcTR2y43MjBwLkhE1tDX1i5tcDR8MTA3OTUyMTcwNnxGRDE4RDBERUZCMjQ0NTkxNTRGMzY5NkZDRDZBQzJCQnxoPVZWVEFTMk4zRVJDUldGUFhUMlJDWFkyWlVYS1NYNU9UfC9aWg=="))
	print(decode("thunder://QUFodHRwOi8vYnQuMnR1LmNjL0U5RjFBRTQ1NEFBRTUxNDFEMTYyOTVEREUzQTA4QUE1RkE5NzMwOEYvsNfNw8zHLkJEMTI4MLjfx+XI1dPv1tDX1i5ybXZiWlo="))
	input()