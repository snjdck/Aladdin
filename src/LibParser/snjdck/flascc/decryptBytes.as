package snjdck.flascc
{
	import flash.utils.ByteArray;

	public function decryptBytes(ba:ByteArray):void
	{
		var ptr:int = CModule.malloc(ba.length);
		CModule.writeBytes(ptr, ba.length, ba);
		decrypt(ptr, ba.length);
		
		ba.position = 0;
		CModule.readBytes(ptr, ba.length, ba);
		CModule.free(ptr);
	}
}