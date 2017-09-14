import struct
import json

__all__ = ["Packet"]

def read_ushort(buffer, offset=0):
	return struct.unpack_from(">H", buffer, offset)[0]

def read_uint(buffer, offset=0):
	return struct.unpack_from(">I", buffer, offset)[0]

def pack_ushort(val):
	return struct.pack(">H", val)

def pack_uint(val):
	return struct.pack(">I", val)

class Packet:
	__slots__ = ("reqId", "usrId", "msgId", "msgData")
	@staticmethod
	def cut(buffer, offset=0):
		count = len(buffer) - offset
		if count < 2: return None
		packetLen = read_ushort(buffer, offset)
		if count < packetLen: return None
		return buffer[offset:offset+packetLen]

	@classmethod
	def decode(klass, buffer):
		reqId = read_ushort(buffer, 2)
		usrId = read_ushort(buffer, 4)
		msgId = read_ushort(buffer, 6)
		msgData = json.loads(buffer[8:].decode()) if len(buffer) > 8 else None
		packet = klass(msgId, msgData, usrId)
		packet.reqId = reqId
		return packet

	def __init__(self, msgId, msgData, usrId=0):
		self.usrId = usrId
		self.msgId = msgId
		self.msgData = msgData
		self.reqId = 0

	def __bytes__(self):
		buffer  = pack_ushort(self.reqId)
		buffer += pack_ushort(self.usrId)
		buffer += pack_ushort(self.msgId)
		if self.msgData:
			buffer += json.dumps(self.msgData, separators=(',', ':')).encode()
		return pack_ushort(len(buffer)+2) + buffer


