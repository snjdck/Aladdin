package snjdck.model3d.importer
{
	import flash.utils.IDataInput;

	public function readIndices(ba:IDataInput, count:int):Vector.<uint>
	{
		var result:Vector.<uint> = new Vector.<uint>(count);
		for(var i:int=0; i<count; ++i){
			result[i] = ba.readUnsignedShort();
		}
		return result;
	}
}