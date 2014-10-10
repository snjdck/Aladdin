package snjdck.g3d.obj3d
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.core.Object3D;
	
	public class Mirror3D extends Object3D
	{
		public var normal:Vector3D = new Vector3D(1, 0, 0);
		
		public function Mirror3D()
		{
			width = 100;
			height = 100;
		}
	}
}