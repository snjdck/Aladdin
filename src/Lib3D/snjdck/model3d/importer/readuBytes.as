package snjdck.model3d.importer
{
	import flash.utils.IDataInput;

	public function readuBytes(ba:IDataInput, count:int):Array
	{
		var result:Array = new Array(count);
		for(var i:int=0; i<count; ++i){
			result[i] = ba.readUnsignedByte();
		}
		return result;
	}
}