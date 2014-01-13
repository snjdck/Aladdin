import socket

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(("127.0.0.1", 843))
server.listen(5)

print server.getsockname()

while True:
	client, address = server.accept()
	print "recv client"
	buff = client.recv(1024)
	print address, buff
	client.sendall('<cross-domain-policy><allow-access-from domain="*" to-ports="*" /></cross-domain-policy>')
	client.close()
	