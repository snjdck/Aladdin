package snjdck.g3d.render
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import matrix44.calcPlaneShadowMatrix;
	
	import snjdck.g2d.core.IRender;
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.asset.helper.AssetMgr;
	import snjdck.g3d.asset.helper.ShaderName;
	import snjdck.g3d.core.BlendMode;
	import snjdck.g3d.ns_g3d;
	
	import stdlib.components.ObjectPool;
	
	use namespace ns_g3d;

	public class Render3D implements IRender
	{
		static private const drawUnitPool:ObjectPool = new ObjectPool(DrawUnit3D);
		private const drawUnitList:Vector.<DrawUnit3D> = new Vector.<DrawUnit3D>();
//		private var shadowMatrix:Matrix3D;
		
		public function Render3D()
		{
//			shadowMatrix = new Matrix3D();
//			calcPlaneShadowMatrix(new Vector3D(1,0,1), new Vector3D(0,0,1,-0.04), shadowMatrix);
		}
		
		public function setScreenSize(width:int, height:int):void
		{
			
		}
		
		private function recoverDrawUnit(drawUnit:DrawUnit3D):void
		{
			drawUnit.clear();
			drawUnitPool.setObjectIn(drawUnit);
		}
		
		public function getFreeDrawUnit():DrawUnit3D
		{
			var drawUnit:DrawUnit3D = drawUnitPool.getObjectOut();
			drawUnitList.push(drawUnit);
			return drawUnit;
		}
		
		public function clear():void
		{
			while(drawUnitList.length > 0){
				recoverDrawUnit(drawUnitList.pop());
			}
		}
		
		/*
		private function preDrawDepth(context3d:IGpuContext, drawUnitList:Vector.<DrawUnit3D>):void
		{
			context3d.setBlendFactor(BlendMode.NORMAL);
			context3d.setProgram(AssetMgr.Instance.getProgram(ShaderName.G3D_PRE_DRAW_DEPTH));
			context3d.setDepthTest(true, Context3DCompareMode.LESS);
			context3d.setColorMask(false, false, false, false);
			for each(var drawUnit:DrawUnit3D in drawUnitList){
				drawUnit.preDrawDepth(context3d);
			}
			context3d.setColorMask(true, true, true, true);
			context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
		}
		public function draw(context3d:IGpuContext, collector:DrawUnitCollector3D, mvpMatrix:Matrix3D):void
		{
			const hasOpaqueDrawUnits:Boolean = collector.opaqueList.length > 0;
			const hasBlendDrawUnits:Boolean = collector.blendList.length > 0;
//			const hasShadowDrawUnits:Boolean = collector.shadowList.length > 0;
			
			if(!(hasOpaqueDrawUnits || hasBlendDrawUnits)){
				return;
			}
			
			context3d.setVcM(0, mvpMatrix);
			
			if(hasOpaqueDrawUnits){
				preDrawDepth(context3d, collector.opaqueList);
				drawUnits(context3d, collector.opaqueList);
			}
			
			if(hasBlendDrawUnits){
				drawUnits(context3d, collector.blendList);
			}
			
			
			if(!(hasBlendDrawUnits || hasShadowDrawUnits)){
				return;
			}
			if(hasShadowDrawUnits){
				context3d.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,
					Context3DCompareMode.EQUAL, Context3DStencilAction.INCREMENT_SATURATE
				);
				
				for each(var drawUnit:DrawUnit3D in collector.shadowList){
					drawUnit.appendTransformAfterWorldMatrix(shadowMatrix);
				}
				drawUnits(context3d, collector.shadowList);
				
				context3d.setStencilActions();
			}
			drawUnits(context3d, collector.blendList);
		}
		
		private function drawUnits(context3d:IGpuContext, drawUnitList:Vector.<DrawUnit3D>):void
		{
			var currentShaderName:String;
			var currentTextureName:String;
			
			for each(var drawUnit:DrawUnit3D in drawUnitList){
				if(drawUnit.shaderName != currentShaderName){
					currentShaderName = drawUnit.shaderName;
					context3d.setProgram(AssetMgr.Instance.getProgram(currentShaderName));
				}
				if(drawUnit.textureName && drawUnit.textureName != currentTextureName){
					currentTextureName = drawUnit.textureName;
					context3d.setTextureAt(0, AssetMgr.Instance.getTexture(currentTextureName));
				}
				drawUnit.exec(context3d);
			}
		}
		*/
		public function renderDrawUnit(drawUnit:DrawUnit3D, context3d:IGpuContext):void
		{
			context3d.setProgram(AssetMgr.Instance.getProgram(drawUnit.shaderName));
			context3d.setTextureAt(0, AssetMgr.Instance.getTexture(drawUnit.textureName));
			drawUnit.exec(context3d);
			
			recoverDrawUnit(drawUnit);
		}
	}
}