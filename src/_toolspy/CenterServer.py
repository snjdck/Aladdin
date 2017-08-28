
from nio import *
from packet import *
import tcp

clientList = []

class Client(PacketSocket):
	def onPacket(self, packet):
		for client in clientList:
			if client is not self:
				client.send(packet)

class Server(ServerSocket):
	def onAccept(self, sock, addr):
		client = Client(sock, Packet)
		clientList.append(client)

server = Server(tcp.serversocket(5678))
while True:
	select()