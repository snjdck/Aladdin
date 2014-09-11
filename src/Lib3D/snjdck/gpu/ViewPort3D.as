package snjdck.gpu
{
	import flash.geom.Matrix3D;
	import flash.geom.d3.createIsoMatrix;
	
	import snjdck.g2d.core.IDisplayObjectContainer2D;
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.render.GpuRender;
	
	use namespace ns_g3d;

	final public class ViewPort3D
	{
		static public const isoMatrix:Matrix3D = createIsoMatrix();
		
		public const scene3d:Object3D = new Object3D();
		public const scene2d:IDisplayObjectContainer2D = new DisplayObjectContainer2D();
		
		public function ViewPort3D(){}
		
		public function update(timeElapsed:int):void
		{
			scene3d.onUpdate(timeElapsed, isoMatrix);
			scene2d.onUpdate(timeElapsed, null, 1);
		}
		
		public function draw(context3d:GpuContext, render:GpuRender):void
		{
			render.drawScene3D(scene3d, context3d);
			render.drawScene2D(scene2d, context3d);
		}
	}
}