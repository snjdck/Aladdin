from mvc import *
from net import *
from nio import *
from packet import *
import tcp
import time
import aio

class Linker(PacketSocket):
	def onPacket(self, packet):
		packet = Packet.decode(packet)
		NetMsgHandler(packet.msgId)(packet)

class NetModule(Module):
	def initAllModels(self):
		self.regModel(Linker(tcp.clientsocket(5678), Packet))

	def initAllServices(self):
		self.regService(NetService, NetService)

	def initAllControllers(self):
		self.regController(NetController)

class NetService(Service, NetMsgHandler):
	client: Inject(Linker)
	@msgid(100)
	def test(self, packet):
		print("service recv data", packet.msgData)
		fiber.call_later(1, self.client.send, packet)
		self.notify("test")

class NetController(Controller):
	@MsgHandler("test")
	def test(self, msg):
		print(msg)

app = Application()
app.regModule(NetModule())
app.startup()

fiber = aio.Fiber()

while True:
	select(1)
	fiber.update()