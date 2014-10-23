package matrix44
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public function extractAxisZ(matrix:Matrix3D, output:Vector3D):void
	{
		var v:Vector.<Number> = matrix.rawData;
		output.x = v[8];
		output.y = v[9];
		output.z = v[10];
	}
}