package snjdck.g3d.obj3d
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.support.QuadRender;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g3d;
	
	public class BillBoard extends Object3D implements IDrawUnit3D
	{
		private var aabb:AABB = new AABB();
		
		public function BillBoard()
		{
			var s:int = 15 * 128;
			aabb.setMinMax(-s, -s, 0, s, s, 0);
		}
		
		public function get bound():AABB
		{
			return aabb;
		}
		
		override protected function onHitTest(localRay:Ray):Boolean
		{
			return aabb.hitRay(localRay, mouseLocation);
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			super.collectDrawUnit(collector);
			collector.addDrawUnit(this);
		}
		
		public function isInSight(camera3d:Camera3D):Boolean
		{
			// TODO Auto Generated method stub
			return camera3d.isInSight(aabb);
		}
		
		
		public function draw(context3d:GpuContext, camera3d:Camera3D):void
		{
			/*
			var t1:Vector.<Vector3D> = cameraWorldMatrix.decompose();
			var t2:Vector.<Vector3D> = worldMatrix.decompose();
			t2[1] = t1[1];
			worldMatrix.recompose(t2);
			*/
			var count:int = 30;
			var tex:IGpuTexture = AssetMgr.Instance.getTexture("terrain");
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.BILLBOARD);
			context3d.texture = tex;
			context3d.blendMode = BlendMode.NORMAL;
			context3d.setVcM(5, prevWorldMatrix);
			context3d.setVc(8, new <Number>[
				count * tex.width, count * tex.height, -0.5, 0,
				count,count,1,1
			]);
			QuadRender.Instance.drawBegin(context3d);
			QuadRender.Instance.drawTriangles(context3d);
		}
		
		public function get shaderName():String
		{
			return ShaderName.BILLBOARD;
		}
	}
}