package flash.utils
{
	import flash.geom.Vector3D;

	final public class Vector3DUtil
	{
		static public function CopyTo(v:Vector3D, dest:Vector.<Number>, offset:int=0, includeW:Boolean=false):void
		{
			dest[offset  ] = v.x;
			dest[offset+1] = v.y;
			dest[offset+2] = v.z;
			if(includeW){
			dest[offset+3] = v.w;
			}
		}
	}
}