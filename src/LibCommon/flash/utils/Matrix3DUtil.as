package flash.utils
{
	import flash.geom.Matrix3D;

	final public class Matrix3DUtil
	{
		static public function Print(m:Matrix3D):void
		{
			var v:Vector.<Number> = m.rawData;
			var result:String = "";
			for(var i:int=0; i<16; ++i){
				result += v[i].toString();
				result += (i % 4 == 3) ? "\n" : ",";
			}
			trace(result);
		}
	}
}