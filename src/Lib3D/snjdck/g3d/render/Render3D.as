package snjdck.g3d.render
{
	import flash.display3D.Context3DCompareMode;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.RayCastStack;
	import snjdck.g3d.pickup.RayTestInfo;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.helper.AssetMgr;
	
	use namespace ns_g3d;

	public class Render3D
	{
		private const collector:DrawUnitCollector3D = new DrawUnitCollector3D();
		
		private const rayCastStack:RayCastStack = new RayCastStack();
		
		public function Render3D(){}
		
		public function draw(scene3d:Object3D, context3d:GpuContext):void
		{
			collector.clear();
			scene3d.collectDrawUnit(collector);
			
			const hasOpaqueDrawUnits:Boolean = collector.opaqueList.length > 0;
			const hasBlendDrawUnits:Boolean = collector.blendList.length > 0;
			
			if(!(hasOpaqueDrawUnits || hasBlendDrawUnits)){
				return;
			}
			
			collector.drawBegin();
			
			for each(var camera3d:Camera3D in collector.cameraList)
			{
				camera3d.drawBegin(context3d);
				
				if(hasOpaqueDrawUnits){
					context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
					drawUnits(context3d, collector.opaqueList);
				}
				
				if(hasBlendDrawUnits){
					context3d.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
					drawUnits(context3d, collector.blendList);
				}
				
				camera3d.drawEnd(context3d);
			}
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
				drawUnit.exec(context3d);
			}
		}
		
		public function pickup(screenX:Number, screenY:Number, result:Vector.<RayTestInfo>):void
		{
			for each(var camera3d:Camera3D in collector.cameraList)
			{
				if(camera3d.mouseEnabled && camera3d.viewport.contains(screenX, screenY)){
					camera3d.getSceneRay(screenX, screenY, rayCastStack.ray);
					camera3d.root.hitTest(rayCastStack, result);
				}
			}
		}
	}
}