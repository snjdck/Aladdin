
from nio import *
from packet import *
import tcp
import time

class Linker(PacketSocket):
	def onPacket(self, packet):
		packet = Packet.decode(packet)
		print("service recv data", packet.msgData)
		time.sleep(1)
		linker.send(packet)

linker = Linker(tcp.clientsocket(5678), Packet)
while True:
	select()