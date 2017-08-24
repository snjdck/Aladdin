from selectors import DefaultSelector, EVENT_READ, EVENT_WRITE

__all__ = ("register", "select", "Socket", "PacketSocket")

selector = DefaultSelector()

def register(sock, data):
	sock.setblocking(False)
	selector.register(sock, EVENT_READ, data)

def select(timeout=None):
	events = selector.select(timeout)
	for key, mask in events:
		key.data(mask)

class Socket:
	def __init__(self, sock):
		self.sock = sock
		self.bufferRecv = bytes()
		self.bufferSend = bytes()

	def __call__(self, mask):
		if mask & EVENT_READ:  self.onRecv()
		if mask & EVENT_WRITE: self.onSend()

	def modify(self, events):
		selector.modify(self.sock, events, self)

	def onError(self):
		selector.unregister(self.sock)
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

class PacketSocket(Socket):
	def __init__(self, sock, Packet):
		super().__init__(sock)
		self.Packet = Packet

	def onRecv(self):
		super().onRecv()
		packetList = []
		offset = 0
		while True:
			packet, size = self.Packet.decode(self.bufferRecv, offset)
			if packet is None: break
			packetList.append(packet)
			offset += size
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
