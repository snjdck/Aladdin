package snjdck.model3d.importer
{
	import flash.utils.IDataInput;
	
	public function readVertices(ba:IDataInput, count:int):Vector.<Number>
	{
		var result:Vector.<Number> = new Vector.<Number>(count * 3);
		for(var i:int=0; i<count; ++i){
			var offset:int = i * 3;
			result[offset  ] = ba.readFloat();
			result[offset+1] = ba.readFloat();
			result[offset+2] = ba.readFloat();
		}
		return result;
	}
}