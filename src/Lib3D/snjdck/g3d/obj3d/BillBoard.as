package snjdck.g3d.obj3d
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.IRenderable;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.support.QuadRender;
	
	public class BillBoard implements IRenderable, IDrawUnit3D
	{
		public function BillBoard()
		{
		}
		
		public function onUpdate(timeElapsed:int):void
		{
		}
		
		public function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			collector.addDrawUnit(this);
		}
		
		public function draw(cameraWorldMatrix:Matrix3D, context3d:GpuContext):void
		{
			context3d.program = AssetMgr.Instance.getProgram("");
			context3d.texture = AssetMgr.Instance.getTexture("shaokai");
			context3d.blendMode = BlendMode.NORMAL;
			QuadRender.Instance.drawBegin(context3d);
			QuadRender.Instance.drawTriangles(context3d);
		}
		
		public function isOpaque():Boolean
		{
			return true;
		}
		
		public function getAABB():AABB
		{
			return null;
		}
	}
}