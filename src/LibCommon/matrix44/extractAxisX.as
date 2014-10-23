package matrix44
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	public function extractAxisX(matrix:Matrix3D, output:Vector3D):void
	{
		var v:Vector.<Number> = matrix.rawData;
		output.x = v[0];
		output.y = v[1];
		output.z = v[2];
	}
}