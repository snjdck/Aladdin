package stdlib.checksum
{
	import flash.utils.ByteArray;

	public function adler32(buffer:ByteArray, startPos:int=0, endPos:int=0):uint
	{
		if(startPos < 0){
			startPos = 0;
		}
		
		if(endPos <= 0){
			endPos += buffer.length;
		}
		
		return encode(buffer, startPos, endPos);
	}
}

import flash.utils.ByteArray;

function encode(buffer:ByteArray, startPos:int, endPos:int):uint
{
	var a:uint = 1;
	var b:uint = 0;
	
	for(var i:int=startPos; i<endPos; i++)
	{
		a = (a + buffer[i]) % MOD_ADLER;
		b = (b + a) % MOD_ADLER;
	}
	
	return (b << 16) | a;
}

/** The largest prime smaller than 65536 */
const MOD_ADLER:uint = 65521;