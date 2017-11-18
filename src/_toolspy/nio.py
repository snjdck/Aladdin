from selectors import DefaultSelector, EVENT_READ, EVENT_WRITE
from time import monotonic

__all__ = ("select", "ServerSocket", "PacketSocket", "AsyncPacketSocket")

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

	def close(self):
		selector.unregister(self)
		self.sock.close()
		self.onClosed()

	def onClosed(self): pass

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

	def onRecv(self):
		try:
			data = self.sock.recv(0x10000)
		except ConnectionResetError:
			self.close()
			return
		if data is None:
			self.close()
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
		self.timestamp = monotonic()

	def onRecv(self):
		super().onRecv()
		packetList = []
		offset = 0
		while True:
			packet = self.Packet.cut(self.bufferRecv, offset)
			if packet is None: break
			packetList.append(packet)
			offset += len(packet)
		if offset == 0: return
		self.timestamp = monotonic()
		self.bufferRecv = self.bufferRecv[offset:]
		for packet in packetList:
			self.onPacket(packet)

	def onPacket(self, packet):
		raise NotImplementedError

	def send(self, data):
		if isinstance(data, self.Packet):
			data = bytes(data)
		super().send(data)

class AsyncPacketSocket(PacketSocket):
	def __init__(self, sock, Packet):
		super().__init__(sock, Packet)
		self.__reqId__ = self.reqIdGen()
		self.__request__ = {}

	@staticmethod
	def reqIdGen():
		initValue = 1
		reqId = initValue
		while True:
			yield reqId
			reqId = reqId + 1 if reqId < 0xFFFF else initValue

	def onPacket(self, packet):
		packet = self.Packet.decode(packet)
		if packet.reqId == 0:
			self.onNotify(packet)
			return
		future = self.__request__.get(packet.reqId)
		if future:
			future.resolve(packet.msgData)
			del self.__request__[packet.reqId]
		else:
			print(packet.reqId, "is not exist!")	

	def onNotify(self, packet):
		raise NotImplementedError

	def request(self, packet):
		reqId = next(self.__reqId__)
		packet.reqId = reqId
		self.send(packet)
		future = RequestFuture()
		self.__request__[reqId] = future
		return future

class RequestFuture:
	__slots__ = ("isDone", "result")

	def __init__(self):
		self.isDone = False

	def __await__(self):
		while not self.isDone:
			yield
		return self.result

	def resolve(self, result):
		self.isDone = True
		self.result = result
