package snjdck.g3d.render
{
	import flash.display3D.Context3DCompareMode;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.helper.AssetMgr;
	import snjdck.gpu.projection.OrthoProjection3D;
	import snjdck.gpu.render.IRender;
	
	use namespace ns_g3d;

	public class Render3D implements IRender
	{
		private const collector:DrawUnitCollector3D = new DrawUnitCollector3D();
		private const projectionStack:Vector.<OrthoProjection3D> = new <OrthoProjection3D>[new OrthoProjection3D()];
		private var projectionIndex:int;
		
		public function Render3D()
		{
//			shadowMatrix = new Matrix3D();
//			calcPlaneShadowMatrix(new Vector3D(1,0,1), new Vector3D(0,0,1,-0.04), shadowMatrix);
		}
		
		private function get projection():OrthoProjection3D
		{
			return projectionStack[projectionIndex];
		}
		
		public function pushScreen(width:int, height:int):void
		{
			++projectionIndex;
			if(projectionStack.length <= projectionIndex){
				projectionStack.push(new OrthoProjection3D());
			}
			projection.resize(width, height);
		}
		
		public function popScreen():void
		{
			projection.offset(0, 0);
			--projectionIndex;
		}
		
		public function offset(dx:Number=0, dy:Number=0):void
		{
			projection.offset(dx, dy);
		}
		
		public function draw(scene3d:Object3D, context3d:GpuContext):void
		{
			scene3d.collectDrawUnit(collector);
			
			const hasOpaqueDrawUnits:Boolean = collector.opaqueList.length > 0;
			const hasBlendDrawUnits:Boolean = collector.blendList.length > 0;
			
			if(hasOpaqueDrawUnits){
				context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
				drawUnits(context3d, collector.opaqueList);
			}
			
			if(hasBlendDrawUnits){
				context3d.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
				drawUnits(context3d, collector.blendList);
			}
			
			collector.clear();
		}
		
		private function drawUnits(context3d:GpuContext, drawUnitList:Vector.<DrawUnit3D>):void
		{
			var currentShaderName:String;
			var currentTextureName:String;
			
			for each(var drawUnit:DrawUnit3D in drawUnitList){
				if(drawUnit.shaderName != currentShaderName){
					currentShaderName = drawUnit.shaderName;
					context3d.program = AssetMgr.Instance.getProgram(currentShaderName);
				}
				if(drawUnit.textureName && drawUnit.textureName != currentTextureName){
					currentTextureName = drawUnit.textureName;
					context3d.setTextureAt(0, AssetMgr.Instance.getTexture(currentTextureName));
				}
				projection.upload(context3d);
				drawUnit.exec(context3d);
			}
		}
	}
}