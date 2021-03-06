package matrix44
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	public function transformCoordsDelta(matrix:Matrix3D, x:Number, y:Number, z:Number, output:Vector3D):void
	{
		var v:Vector.<Number> = matrix.rawData;
		output.x = (v[0] * x) + (v[4] * y) + (v[8] * z);
		output.y = (v[1] * x) + (v[5] * y) + (v[9] * z);
		output.z = (v[2] * x) + (v[6] * y) + (v[10]* z);
	}
}