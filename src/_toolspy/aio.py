from select import select
from time import monotonic as time
from heapq import heappush, heappop

__all__ = ("Fiber", "Sleep", "AsyncSocket")

def readable(sock):
	return len(select([sock], (), (), 0)[0]) > 0

def writable(sock):
	return len(select((), [sock], (), 0)[1]) > 0

class Sleep:
	__slots__ = ("timeout",)
	def __init__(self, seconds):
		self.timeout = time() + seconds

	def __await__(self):
		while time() < self.timeout:
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
	__slots__ = ("sock",)
	def __await__(self):
		while not readable(self.sock):
			yield
		sock, addr = self.sock.accept()
		return AsyncSocket(sock), addr

class Recv(SocketHandler):
	__slots__ = ("sock", "count")
	def __await__(self):
		while not readable(self.sock):
			yield
		return self.sock.recv(self.count)

class Send(SocketHandler):
	__slots__ = ("sock", "data")
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

class Handle:
	__slots__ = ("callback", "args", "cancelFlag", "when")
	def __init__(self, callback, args, when=0):
		self.callback = callback
		self.args = args
		self.cancelFlag = False

	def cancel(self):
		if self.cancelFlag: return
		self.cancelFlag = True
		self.callback = None
		self.args = None

	def __call__(self):
		if self.cancelFlag: return
		self.callback(*self.args)

class Fiber:
	def __init__(self):
		self.queue = []
		self.timer = []

	def time(self):
		return time()

	def call_soon(callback, *args):
		handle = Handle(callback, args)
		self.queue.append(handle)
		return handle

	def call_later(self, delay, callback, *args):
		return self.call_at(self.time() + delay, callback, *args)

	def call_at(self, when, callback, *args):
		handle = Handle(callback, args, when)
		heappush(self.timer, handle)
		return handle

	def run_until_complete(self, future):
		while True:
			try:
				future.send(None)
				while len(self.queue):
					self.queue.pop(0)()
				while len(self.timer) and self.timer[0].when >= time():
					heappop(self.timer)()
			except StopIteration as error:
				return error.value
