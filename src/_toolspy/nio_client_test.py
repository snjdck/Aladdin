import socket
import nio
from packet import *
import tcp
import time


class ClientSocket(nio.PacketSocket):
	def onPacket(self, packet):
		packet = Packet.decode(packet)
		print(packet.msgId, packet.msgData)
		self.send(packet)

packetSocket = ClientSocket(tcp.clientsocket(1234), Packet)
packetSocket.send(Packet(100, {"key":"alex"}))

while True:
	nio.select()