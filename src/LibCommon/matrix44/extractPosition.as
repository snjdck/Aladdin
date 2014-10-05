package matrix44
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public function extractPosition(matrix:Matrix3D, output:Vector3D):void
	{
		var v:Vector.<Number> = matrix.rawData;
		output.x = v[12];
		output.y = v[13];
		output.z = v[14];
	}
}