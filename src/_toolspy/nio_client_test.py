import socket
import nio
import packet
import time

sock = socket.socket()
sock.connect(('localhost', 1234))

class ClientSocket(nio.PacketSocket):
	def onPacket(self, packet):
		print(packet.msgId, packet.msgData)
		self.send(packet)

packetSocket = ClientSocket(sock, packet.Packet)
packetSocket.send(packet.Packet(100, {"key":"alex"}))

while True:
	nio.select()