import struct
import json

def read_ushort(buffer, offset=0):
	return struct.unpack_from(">H", buffer, offset)[0]

def read_uint(buffer, offset=0):
	return struct.unpack_from(">I", buffer, offset)[0]

def pack_ushort(val):
	return struct.pack(">H", val)

def pack_uint(val):
	return struct.pack(">I", val)

class Packet:
	@classmethod
	def decode(klass, buffer, offset=0):
		count = len(buffer) - offset
		if count < 2: return None, 0
		packetLen = read_ushort(buffer, offset)
		if count < packetLen: return None, 0
		msgId = read_ushort(buffer, offset+2)
		msgData = json.loads(buffer[offset+4:].decode()) if packetLen > 4 else None
		return klass(msgId, msgData), packetLen

	def __init__(self, msgId, msgData):
		self.msgId = msgId
		self.msgData = msgData

	def __bytes__(self):
		buffer = pack_ushort(msgId)
		if msgData:
			buffer += json.dumps(msgData, separators=(',', ':')).encode()
		return pack_ushort(len(buffer)) + buffer


