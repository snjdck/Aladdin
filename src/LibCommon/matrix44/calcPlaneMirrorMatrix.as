package matrix44
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public function calcPlaneMirrorMatrix(normal:Vector3D, pt:Vector3D, output:Matrix3D):void
	{
		var factor:Number = 1 / normal.length;
		
		var nx:Number = normal.x * factor;
		var ny:Number = normal.y * factor;
		var nz:Number = normal.z * factor;
		var d:Number = normal.dotProduct(pt) * factor;
		
		var xx2:Number = -2 * nx * nx;
		var xy2:Number = -2 * nx * ny;
		var xz2:Number = -2 * nx * nz;
		var yy2:Number = -2 * ny * ny;
		var yz2:Number = -2 * ny * nz;
		var zz2:Number = -2 * nz * nz;
		
		var xd2:Number = 2 * nx * d;
		var yd2:Number = 2 * ny * d;
		var zd2:Number = 2 * nz * d;
		
		var rawData:Vector.<Number> = output.rawData;
		
		rawData[0] = xx2 + 1;
		rawData[4] = xy2;
		rawData[8] = xz2;
		rawData[12] = xd2;
		
		rawData[1] = xy2;
		rawData[5] = yy2 + 1;
		rawData[9] = yz2;
		rawData[13] = yd2;
		
		rawData[2] = xz2;
		rawData[6] = yz2;
		rawData[10] = zz2 + 1;
		rawData[14] = zd2;
		
		output.rawData = rawData;
	}
}