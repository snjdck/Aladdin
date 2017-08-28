import socket

def clientsocket(port, host="127.0.0.1"):
	sock = socket.socket()
	sock.connect((host, port))
	return sock

def serversocket(port, host="127.0.0.1"):
	sock = socket.socket()
	sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	sock.bind((host, port))
	sock.listen()
	return sock
