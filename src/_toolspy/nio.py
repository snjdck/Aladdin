from selectors import DefaultSelector, EVENT_READ, EVENT_WRITE

__all__ = ("select", "ServerSocket", "PacketSocket")

selector = DefaultSelector()

def select(timeout=None):
	events = selector.select(timeout)
	for key, mask in events:
		key.fileobj(mask)

class Socket:
	def __init__(self, sock):
		self.sock = sock
		sock.setblocking(False)
		selector.register(self, EVENT_READ)

	def fileno(self):
		return self.sock.fileno()

class ServerSocket(Socket):
	def __call__(self, mask):
		sock, addr = self.sock.accept()
		self.onAccept(sock, addr)

	def onAccept(self, sock, addr):
		raise NotImplementedError

class ClientSocket(Socket):
	def __init__(self, sock):
		super().__init__(sock)
		self.bufferRecv = bytes()
		self.bufferSend = bytes()

	def __call__(self, mask):
		if mask & EVENT_READ:  self.onRecv()
		if mask & EVENT_WRITE: self.onSend()

	def modify(self, events):
		selector.modify(self, events)

	def onError(self):
		selector.unregister(self)
		self.sock.close()

	def onRecv(self):
		try:
			data = self.sock.recv(0x10000)
		except ConnectionResetError:
			self.onError()
			return
		if data is None:
			self.onError()
			return
		self.bufferRecv += data

	def onSend(self):
		n = self.sock.send(self.bufferSend)
		if n <= 0:
			assert False
		elif n < len(self.bufferSend):
			self.bufferSend = self.bufferSend[n:]
		else:
			self.bufferSend = bytes()
			self.modify(EVENT_READ)

	def send(self, data):
		if len(data) == 0: return
		if len(self.bufferSend) == 0:
			self.modify(EVENT_READ | EVENT_WRITE)
		self.bufferSend += data

class PacketSocket(ClientSocket):
	def __init__(self, sock, Packet):
		super().__init__(sock)
		self.Packet = Packet

	def onRecv(self):
		super().onRecv()
		packetList = []
		offset = 0
		while True:
			packet = self.Packet.cut(self.bufferRecv, offset)
			if packet is None: break
			packetList.append(packet)
			offset += len(packet)
		if offset:
			self.bufferRecv = self.bufferRecv[offset:]
		for packet in packetList:
			self.onPacket(packet)

	def onPacket(self, packet):
		raise NotImplementedError

	def send(self, data):
		if isinstance(data, self.Packet):
			data = bytes(data)
		super().send(data)
