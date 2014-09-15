package snjdck.g3d.render
{
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Matrix3D;
	import flash.geom.d3.createIsoMatrix;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.View3D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.helper.AssetMgr;
	import snjdck.gpu.projection.OrthoProjection3D;
	import snjdck.gpu.projectionstack.IProjectionStack;
	import snjdck.gpu.projectionstack.OrthoProjection3DStack;
	import snjdck.gpu.render.IRender;
	
	use namespace ns_g3d;

	public class Render3D implements IRender, IProjectionStack
	{
		static public const isoMatrix:Matrix3D = createIsoMatrix();
		
		private const collector:DrawUnitCollector3D = new DrawUnitCollector3D();
		private const projectionStack:OrthoProjection3DStack = new OrthoProjection3DStack();
		
		public function Render3D()
		{
			collector.pushMatrix(isoMatrix);
//			shadowMatrix = new Matrix3D();
//			calcPlaneShadowMatrix(new Vector3D(1,0,1), new Vector3D(0,0,1,-0.04), shadowMatrix);
		}
		
		public function pushScreen(width:int, height:int, offsetX:Number=0, offsetY:Number=0):void
		{
			projectionStack.pushScreen(width, height, offsetX, offsetY);
		}
		
		public function popScreen():void
		{
			projectionStack.popScreen();
		}
		
		public function offset(dx:Number=0, dy:Number=0):void
		{
			projectionStack.projection.offset(dx, dy);
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
				projectionStack.projection.upload(context3d);
				drawUnit.exec(context3d);
			}
		}
	}
}