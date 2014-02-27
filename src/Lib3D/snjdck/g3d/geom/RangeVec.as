package snjdck.g3d.geom
{
	import flash.geom.Vector3D;
	
	import flash.support.Range;

	final public class RangeVec
	{
		static public function Create(baseVal:Vector3D, varVal:Vector3D):RangeVec
		{
			var result:RangeVec = new RangeVec(null, null);
			result.vx = Range.Create(baseVal.x, varVal.x);
			result.vy = Range.Create(baseVal.y, varVal.y);
			result.vz = Range.Create(baseVal.z, varVal.z);
			result.vw = Range.Create(baseVal.w, varVal.w);
			return result;
		}
		
		private var vx:Range;
		private var vy:Range;
		private var vz:Range;
		private var vw:Range;
		
		public function RangeVec(beginValue:Vector3D, endValue:Vector3D)
		{
			if(beginValue && endValue)
			{
				vx = new Range(beginValue.x, endValue.x);
				vy = new Range(beginValue.y, endValue.y);
				vz = new Range(beginValue.z, endValue.z);
				vw = new Range(beginValue.w, endValue.w);
			}
		}
		
		public function getRandowValue(result:Vector3D):void
		{
			result.x = vx.getRandowValue();
			result.y = vy.getRandowValue();
			result.z = vz.getRandowValue();
			result.w = vw.getRandowValue();
		}
	}
}