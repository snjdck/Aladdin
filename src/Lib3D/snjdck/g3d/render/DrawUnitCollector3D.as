package snjdck.g3d.render
{
	import flash.display3D.Context3DCompareMode;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Camera3D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g3d;

	final public class DrawUnitCollector3D
	{
		private const opaqueDrawUnits:DrawUnitGroup = new DrawUnitGroup();
		private const blendDrawUnits:DrawUnitGroup = new DrawUnitGroup();
		
		public function DrawUnitCollector3D(){}
		
		public function hasDrawUnits():Boolean
		{
			return opaqueDrawUnits.hasDrawUnits() || blendDrawUnits.hasDrawUnits();
		}
		
		public function clear():void
		{
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
		}
		
		public function render(context3d:GpuContext, camera3d:Camera3D):void
		{
			if(opaqueDrawUnits.hasDrawUnits()){
				context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
				context3d.blendMode = BlendMode.NORMAL;
				opaqueDrawUnits.draw(context3d, camera3d, false);
			}
			if(blendDrawUnits.hasDrawUnits()){
				context3d.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
				blendDrawUnits.draw(context3d, camera3d, true);
			}
		}
		
		public function preDrawDepth(context3d:GpuContext, camera3d:Camera3D):void
		{
			var staticDrawUnits:Vector.<IDrawUnit3D> = opaqueDrawUnits.getStaticDrawUnits();
			if(staticDrawUnits.length <= 0){
				return;
			}
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.G3D_PRE_DRAW_DEPTH);
			for each(var drawUnit:IDrawUnit3D in staticDrawUnits){
				drawUnit.draw(context3d, camera3d);
			}
		}
	}
}