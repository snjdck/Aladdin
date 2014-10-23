package matrix44
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	public function extractAxisY(matrix:Matrix3D, output:Vector3D):void
	{
		var v:Vector.<Number> = matrix.rawData;
		output.x = v[4];
		output.y = v[5];
		output.z = v[6];
	}
}