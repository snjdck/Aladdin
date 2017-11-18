import socket
import nio
import aio
from packet import *
import tcp
import time


class ClientSocket(nio.AsyncPacketSocket):
	pass
	"""
	def onPacket(self, packet):
		packet = Packet.decode(packet)
		print(packet.msgId, packet.msgData)
		self.send(packet)
	"""

packetSocket = ClientSocket(tcp.clientsocket(1234), Packet)
#packetSocket.send(Packet(100, {"key":"alex"}))

async def fuck():
	result = await packetSocket.request(Packet(100, {"key":"alex"}))
	print("responce", result)



fiber = aio.Fiber()

fiber.add(fuck())

while True:
	nio.select(1)
	fiber.update()