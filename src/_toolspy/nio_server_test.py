from enum import Enum, unique
import socket
import nio
import aio
import packet
from mvc import *
from net import *

class NetModule(Module):
	def initAllServices(self):
		self.regService(NetService, NetService)

	def initAllControllers(self):
		self.regController(NetController)

class NetService(Service, NetMsgHandler):
	@msgid(100)
	def test(self, client, packet):
		print("service recv data", packet.msgData)
		fiber.call_later(1, client.send, packet)
		self.notify("test")

class NetController(Controller):
	@MsgHandler("test")
	def test(self, msg):
		print(msg)

sock = socket.socket()
sock.bind(('localhost', 1234))
sock.listen(100)

class Client(nio.PacketSocket):
	def onPacket(self, packet):
		print(packet.msgId, packet.msgData)
		NetMsgHandler(packet.msgId)(self, packet)

class Server(nio.ServerSocket):
	def onAccept(self, sock, addr):
		print('accepted', sock, 'from', addr)
		client = Client(sock, packet.Packet)

app = Application()
app.regModule(NetModule())
app.startup()

fiber = aio.Fiber()
Server(sock)
while True:
	nio.select(1)
	fiber.update()