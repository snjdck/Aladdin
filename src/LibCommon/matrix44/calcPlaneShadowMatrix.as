package matrix44
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public function calcPlaneShadowMatrix(lightDir:Vector3D, plane:Vector3D, output:Matrix3D):void
	{
		//平面法线
		const a:Number = plane.x;
		const b:Number = plane.y;
		const c:Number = plane.z;
		//平面到原点的距离
		const d:Number = plane.w;
		
		const lx:Number = lightDir.x;
		const ly:Number = lightDir.y;
		const lz:Number = lightDir.z;
		
		rawData[0] = b * ly + c * lz;
		rawData[1] = -b * lx;
		rawData[2] = -c * lx;
		rawData[3] = -d * lx;
		
		rawData[4] = -a * ly;
		rawData[5] = a * lx + c * lz;
		rawData[6] = -c * ly;
		rawData[7] = -d * ly;
		
		rawData[8] = -a * lz;
		rawData[9] = -b * lz;
		rawData[10] = a * lx + b * ly;
		rawData[11] = -d * lz;
		
		rawData[12] = rawData[13] = rawData[14] = 0;
		rawData[15] = a * lx + b * ly + c * lz;
		
		output.copyRawDataFrom(rawData, 0, true);
	}
}

const rawData:Vector.<Number> = new Vector.<Number>(16, true);