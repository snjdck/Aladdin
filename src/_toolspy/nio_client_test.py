import socket
import nio
from packet import *
import time

sock = socket.socket()
sock.connect(('localhost', 1234))

class ClientSocket(nio.PacketSocket):
	def onPacket(self, packet):
		packet = Packet.decode(packet)
		print(packet.msgId, packet.msgData)
		self.send(packet)

packetSocket = ClientSocket(sock, Packet)
packetSocket.send(Packet(100, {"key":"alex"}))

while True:
	nio.select()