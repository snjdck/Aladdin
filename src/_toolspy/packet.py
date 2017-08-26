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
	@staticmethod
	def cut(buffer, offset=0):
		count = len(buffer) - offset
		if count < 2: return None
		packetLen = read_ushort(buffer, offset)
		if count < packetLen: return None
		return buffer[offset:offset+packetLen]

	@classmethod
	def decode(klass, buffer):
		msgId = read_ushort(buffer, 2)
		msgData = json.loads(buffer[4:].decode()) if len(buffer) > 4 else None
		return klass(msgId, msgData)

	def __init__(self, msgId, msgData):
		self.msgId = msgId
		self.msgData = msgData

	def __bytes__(self):
		buffer = pack_ushort(self.msgId)
		if self.msgData:
			buffer += json.dumps(self.msgData, separators=(',', ':')).encode()
		return pack_ushort(len(buffer)+2) + buffer


