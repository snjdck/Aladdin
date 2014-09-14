package snjdck.g3d.geom
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.render.Render3D;

	public class RayTestInfo
	{
		public var target:Object3D;
		
		public var u:Number;
		public var v:Number;
		public var t:Number;
		
		public var localPos:Vector3D;
		
		public function RayTestInfo()
		{
		}
		
		public function get globalPos():Vector3D
		{
			var matrix:Matrix3D = target.worldMatrix;
			matrix.append(Render3D.isoMatrix);
			return matrix.transformVector(localPos);
		}
	}
}