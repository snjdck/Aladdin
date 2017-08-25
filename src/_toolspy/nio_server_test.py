import socket
import nio
import aio
import packet

sock = socket.socket()
sock.bind(('localhost', 1234))
sock.listen(100)

taskList = []

class Client(nio.PacketSocket):
	def onPacket(self, packet):
		print(packet.msgId, packet.msgData)
		fiber.call_later(1, self.send, packet)

class Server(nio.ServerSocket):
	def onAccept(self, sock, addr):
		print('accepted', sock, 'from', addr)
		client = Client(sock, packet.Packet)
		#client.send(packet.Packet(100, {"key":"alex"}))

fiber = aio.Fiber()
Server(sock)
while True:
	nio.select(1)
	fiber.update()