package snjdck.gpu.support
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import vec3.copyToArray;

	final public class GpuConstData
	{
		static public function SetMatrix(dest:Vector.<Number>, regIndex:int, value:Matrix3D):void
		{
			value.copyRawDataTo(dest, regIndex << 2, true);
		}
		
		static public function SetVector(dest:Vector.<Number>, regIndex:int, value:Vector3D, includeW:Boolean=false):void
		{
			vec3.copyToArray(value, dest, regIndex << 2, includeW);
		}
		
		static public function SetNumber(dest:Vector.<Number>, regIndex:int, x:Number, y:Number, z:Number, w:Number):void
		{
			var offset:int = regIndex << 2;
			dest[offset  ] = x;
			dest[offset+1] = y;
			dest[offset+2] = z;
			dest[offset+3] = w;
		}
	}
}