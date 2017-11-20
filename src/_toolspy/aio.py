from time import monotonic as now
from heapq import heappush, heappop
import types
from nio import PacketSocket

__all__ = ("Fiber", "Sleep", "AsyncPacketSocket")

class Sleep:
	def __init__(self, seconds):
		self.timeout = now() + seconds

	def __await__(self):
		while now() < self.timeout:
			yield

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

	def request(self, packet, timeout=10):
		reqId = next(self.__reqId__)
		packet.reqId = reqId
		self.send(packet)
		future = RequestFuture(timeout)
		self.__request__[reqId] = future
		return future

class RequestFuture:
	def __init__(self, timeout):
		self.isDone = False
		self.expireAt = now() + timeout

	def __await__(self):
		while True:
			if self.isDone:
				return self.result
			if self.expireAt <= now():
				raise TimeoutError
			yield

	def resolve(self, result):
		self.isDone = True
		self.result = result


class Future:
	def __init__(self, coroutine):
		self.coroutine = coroutine
		self.isDone = False

	def next(self):
		try:
			self.coroutine.send(None)
		except StopIteration as error:
			self.isDone = True
			self.result = error.value
		except Exception as error:
			self.isDone = True
			raise

class Handle:
	__slots__ = ("callback", "args", "cancelFlag", "when")
	def __init__(self, callback, args, when=0):
		self.callback = callback
		self.args = args
		self.cancelFlag = False
		self.when = when

	def cancel(self):
		if self.cancelFlag: return
		self.cancelFlag = True
		self.callback = None
		self.args = None

	def __call__(self):
		if self.cancelFlag: return
		self.callback(*self.args)

	def __bool__(self):
		return self.when <= now()

	def __lt__(self, other):
		return self.when < other.when

class Fiber:
	def __init__(self):
		self.futureList = []
		self.timer = []

	def time(self):
		return now()

	def call_later(self, delay, callback, *args):
		return self.call_at(self.time() + delay, callback, *args)

	def call_at(self, when, callback, *args):
		handle = Handle(callback, args, when)
		heappush(self.timer, handle)
		return handle

	def add(self, coroutine):
		if isinstance(coroutine, types.CoroutineType):
			future = Future(coroutine)
		self.futureList.append(future)
		return future

	def update(self):
		if self.futureList:
			future = self.futureList.pop(0)
			future.next()
			if not future.isDone:
				self.futureList.append(future)
		while self.timer and self.timer[0]:
			heappop(self.timer)()
