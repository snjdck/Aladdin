package snjdck.model3d.importer
{
	import flash.utils.IDataInput;
	
	import snjdck.g3d.geom.Quaternion;

	public function readQuaternion(buffer:IDataInput, result:Quaternion):void
	{
		result.x = buffer.readFloat();
		result.y = buffer.readFloat();
		result.z = buffer.readFloat();
		result.w = buffer.readFloat();
	}
}