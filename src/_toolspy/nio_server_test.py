from enum import Enum, unique
import socket
import nio
import aio
from packet import *
from mvc import *
from net import *
import tcp

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

class Client(nio.PacketSocket):
	def onPacket(self, packet):
		packet = Packet.decode(packet)
		print(packet.msgId, packet.msgData)
		NetMsgHandler(packet.msgId)(self, packet)

class Server(nio.ServerSocket):
	def onAccept(self, sock, addr):
		print('accepted', sock, 'from', addr)
		client = Client(sock, Packet)

app = Application()
app.regModule(NetModule())
app.startup()

fiber = aio.Fiber()
Server(tcp.serversocket(1234))
while True:
	nio.select(1)
	fiber.update()