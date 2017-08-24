import time
from select import select

def readable(sock):
	return len(select([sock], (), (), 0)[0]) > 0

def writable(sock):
	return len(select((), [sock], (), 0)[1]) > 0

class Sleep:
	def __init__(self, seconds):
		self.timeout = time.time() + seconds

	def __await__(self):
		while time.time() < self.timeout:
			yield

class SocketHandler:
	def __init__(self, sock):
		self.sock = sock

class AsyncSocket:
	def __init__(self, sock):
		self.sock = sock
		sock.setblocking(False)
		self._accept = Accept(sock)
		self._recv = Recv(sock)
		self._send = Send(sock)

	async def accept(self):
		return await self._accept

	async def recv(self, count=0x10000):
		self._recv.count = count
		return await self._recv

	async def send(self, data):
		self._send.data = data
		await self._send

class Accept(SocketHandler):
	def __await__(self):
		while not readable(self.sock):
			yield
		sock, addr = self.sock.accept()
		return AsyncSocket(sock), addr

class Recv(SocketHandler):
	def __await__(self):
		while not readable(self.sock):
			yield
		return self.sock.recv(self.count)

class Send(SocketHandler):
	def __await__(self):
		while True:
			while not writable(self.sock):
				yield
			count = self.sock.send(self.data)
			if count < len(self.data):
				self.data = self.data[count:]
				yield
				continue
			return
