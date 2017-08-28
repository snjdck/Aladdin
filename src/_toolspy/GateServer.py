
from nio import *
from packet import *
import tcp

usrIdPool = list(reversed(range(0x10000)))
clientDict = {}

class Linker(PacketSocket):
	def onPacket(self, packet):
		packet = Packet.decode(packet)
		client = clientDict[packet.usrId]
		client.send(packet)

class Client(PacketSocket):
	def onPacket(self, packet):
		packet = Packet.decode(packet)
		packet.usrId = self.usrId
		linker.send(packet)

class Server(ServerSocket):
	def onAccept(self, sock, addr):
		client = Client(sock, Packet)
		client.usrId = usrIdPool.pop()
		clientDict[client.usrId] = client

linker = Linker(tcp.clientsocket(5678), Packet)
server = Server(tcp.serversocket(1234))
while True:
	select()