package stream
{
	import flash.geom.Matrix3D;
	import flash.utils.IDataInput;

	public function readMatrix34(buffer:IDataInput, output:Matrix3D):void
	{
		var rawData:Vector.<Number> = output.rawData;
		rawData[0] = buffer.readFloat();
		rawData[1] = buffer.readFloat();
		rawData[2] = buffer.readFloat();
		rawData[4] = buffer.readFloat();
		rawData[5] = buffer.readFloat();
		rawData[6] = buffer.readFloat();
		rawData[8] = buffer.readFloat();
		rawData[9] = buffer.readFloat();
		rawData[10] = buffer.readFloat();
		rawData[12] = buffer.readFloat();
		rawData[13] = buffer.readFloat();
		rawData[14] = buffer.readFloat();
		output.rawData = rawData;
	}
}