package snjdck.g3d.render
{
	import flash.display3D.Context3DCompareMode;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.rendersystem.RenderSystem;
	import snjdck.g3d.rendersystem.subsystems.RenderPriority;
	import snjdck.g3d.rendersystem.subsystems.RenderSystemFactory;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;

	public class DrawUnitCollector3D
	{
		private const drawUnitList:Vector.<IDrawUnit3D> = new Vector.<IDrawUnit3D>();
		
		private const system:RenderSystem = RenderSystemFactory.CreateRenderSystem();
		
		public function DrawUnitCollector3D(){}
		
		public function clear():void
		{
			drawUnitList.length = 0;
		}
		
		public function isInSight(bound:AABB):Boolean
		{
			return true;
		}
		
		public function addDrawUnit(drawUnit:IDrawUnit3D, priority:int):void
		{
			assert(drawUnit != null);
//			var priority:int = drawUnit.blendMode.isOpaque() ? RenderPriority.OPAQUE : RenderPriority.BLEND;
			system.addItem(drawUnit, priority);
			drawUnitList.push(drawUnit);
		}
		
		public function addItem(drawUnit:Object, priority:int):void
		{
			system.addItem(drawUnit, priority);
			if(drawUnit is IDrawUnit3D){
				drawUnitList.push(drawUnit);
			}
		}
		
		public function draw(context3d:GpuContext):void
		{
			system.render(context3d);
		}
		
		public function hitTest(worldRay:Ray, result:Vector.<Object3D>):void
		{
			if(drawUnitList.length <= 0)
				return;
			for each(var drawUnit:IDrawUnit3D in drawUnitList)
				drawUnit.hitTest(worldRay, result);
		}
	}
}