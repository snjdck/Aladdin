package snjdck.g3d.obj3d
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.IRenderable;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.support.QuadRender;
	import snjdck.shader.ShaderName;
	
	public class BillBoard implements IRenderable, IDrawUnit3D
	{
		private const worldMatrix:Matrix3D = new Matrix3D();
		
		public function BillBoard()
		{
		}
		
		public function onUpdate(timeElapsed:int):void
		{
		}
		
		public function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			worldMatrix.copyFrom(collector.worldMatrix);
			collector.addDrawUnit(this);
		}
		
		public function draw(cameraWorldMatrix:Matrix3D, context3d:GpuContext):void
		{
			/*
			var t1:Vector.<Vector3D> = cameraWorldMatrix.decompose();
			var t2:Vector.<Vector3D> = worldMatrix.decompose();
			t2[1] = t1[1];
			worldMatrix.recompose(t2);
			*/
			var tex:IGpuTexture = AssetMgr.Instance.getTexture("shaokai");
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.BILLBOARD);
			context3d.texture = tex;
			context3d.blendMode = BlendMode.NORMAL;
			context3d.setVcM(5, worldMatrix);
			context3d.setVc(8, new <Number>[tex.width, tex.height, -0.5, 0]);
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