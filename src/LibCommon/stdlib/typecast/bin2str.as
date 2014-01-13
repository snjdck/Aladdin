package stdlib.typecast
{
	import flash.utils.ByteArray;

	public function bin2str(bin:Class):String
	{
		var ba:ByteArray = new bin();
		return ba.toString();
	}
}