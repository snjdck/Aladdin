package snjdck.g3d.core
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.projection.Projection3D;
	import snjdck.g3d.render.CameraUnit3D;
	import snjdck.g3d.render.DrawUnitCollector3D;
	
	use namespace ns_g3d;

	final public class Camera3D extends Object3D
	{
		public var projection:Projection3D;
		public const viewport:Viewport = new Viewport();
		public var clipViewport:Boolean = true;
		public var cullingMask:uint;
		public var depth:int;
		public var zOffset:Number = 0;
		
		private const drawUnit:CameraUnit3D = new CameraUnit3D();
		
		public function Camera3D(){}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			collector.pushMatrix(transform);
			drawUnit.reset(this, collector.worldMatrix, zOffset);
			collector.addCamera(drawUnit);
			collector.popMatrix();
		}
	}
}