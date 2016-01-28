package snjdck.g3d.render
{
	import flash.display3D.Context3DCompareMode;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.Ray;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;

	final public class DrawUnitCollector3D
	{
		private const drawUnitList:Vector.<IDrawUnit3D> = new Vector.<IDrawUnit3D>();
		private const opaqueDrawUnits:DrawUnitGroup = new DrawUnitGroup();
		private const blendDrawUnits:DrawUnitGroup = new DrawUnitGroup();
		
		public function DrawUnitCollector3D(){}
		
		public function hasDrawUnits():Boolean
		{
			return drawUnitList.length > 0;
		}
		
		public function clear():void
		{
			drawUnitList.length = 0;
			opaqueDrawUnits.clear();
			blendDrawUnits.clear();
		}
		
		public function addDrawUnit(drawUnit:IDrawUnit3D):void
		{
			if(drawUnit.blendMode.isOpaque()){
				opaqueDrawUnits.addDrawUnit(drawUnit);
			}else{
				blendDrawUnits.addDrawUnit(drawUnit);
			}
			drawUnitList.push(drawUnit);
		}
		
		public function render(context3d:GpuContext):void
		{
			if(opaqueDrawUnits.hasDrawUnits()){
				context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
				context3d.blendMode = BlendMode.NORMAL;
				opaqueDrawUnits.draw(context3d, false);
			}
			if(blendDrawUnits.hasDrawUnits()){
				context3d.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
				blendDrawUnits.draw(context3d, true);
			}
		}
		
		public function update(timeElapsed:int):void
		{
			if(drawUnitList.length <= 0)
				return;
			for each(var drawUnit:IDrawUnit3D in drawUnitList)
				drawUnit.onUpdate(timeElapsed);
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