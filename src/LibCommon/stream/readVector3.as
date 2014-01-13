package stream
{
	import flash.geom.Vector3D;
	import flash.utils.IDataInput;

	public function readVector3(buffer:IDataInput, output:Vector3D):void
	{
		output.setTo(buffer.readFloat(), buffer.readFloat(), buffer.readFloat());
	}
}