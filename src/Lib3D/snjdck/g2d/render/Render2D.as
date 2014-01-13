package snjdck.g2d.render
{
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Matrix;
	
	import matrix33.toBuffer;
	
	import snjdck.g2d.support.QuadBatch;
	import snjdck.g2d.support.VertexData;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.asset.IGpuTexture;
	import snjdck.g3d.asset.helper.AssetMgr;
	import snjdck.g3d.asset.helper.ShaderName;
	import snjdck.g3d.core.BlendMode;
	
	use namespace ns_g3d;

	public class Render2D
	{
		private const quadBatch:QuadBatch = new QuadBatch();
		
		private const projectionMatrix:Matrix = new Matrix();
		private const projectionMatrixBuffer:Vector.<Number> = new Vector.<Number>(8, true);
		private var isProjectionMatrixDirty:Boolean;
		
		public function Render2D()
		{
		}
		
		public function setOrthographicProjection(width:Number, height:Number):void
		{
			projectionMatrix.setTo(2.0/width, 0, 0, -2.0/height, -1.0, 1.0);
			isProjectionMatrixDirty = true;
		}
		
		private function uploadProjectionMatrix(context3d:IGpuContext):void
		{
			if(isProjectionMatrixDirty){
				matrix33.toBuffer(projectionMatrix, projectionMatrixBuffer);
				isProjectionMatrixDirty = false;
			}
			context3d.setVc(0, projectionMatrixBuffer, 2);
		}
		
		public function preDrawDepth(context3d:IGpuContext, collector:DrawUnitCollector2D):void
		{
			if(!collector.hasOpaqueDrawUnits()){
				return;
			}
			
			uploadProjectionMatrix(context3d);
			context3d.setDepthTest(true, Context3DCompareMode.LESS);
			context3d.setBlendFactor(BlendMode.NORMAL);
			context3d.setProgram(AssetMgr.Instance.getProgram(ShaderName.G2D_PRE_DRAW_DEPTH));
			
			context3d.setColorMask(false, false, false, false);
			/*
			for each(var drawUnit:DrawUnit2D in collector.opaqueQuadList)
			{
				drawUnit.getVertexData(sharedVertexData);
				quadBatch.addQuad(sharedVertexData);
			}
			*/
			var drawUnit:DrawUnit2D = collector.opaqueQuadHead;
			for(; drawUnit; drawUnit=drawUnit.next){
				drawUnit.getVertexData(sharedVertexData);
				quadBatch.addQuad(sharedVertexData);
			}
			
			quadBatch.draw(context3d, null);
			quadBatch.clear();
			
			context3d.setColorMask(true, true, true, true);
		}
		
		public function draw(context3d:IGpuContext, collector:DrawUnitCollector2D):void
		{
			const hasOpaqueDrawUnits:Boolean = collector.hasOpaqueDrawUnits();
			const hasBlendDrawUnits:Boolean = collector.hasBlendDrawUnits();
			if(!(hasOpaqueDrawUnits || hasBlendDrawUnits)){
				return;
			}
			context3d.setProgram(AssetMgr.Instance.getProgram(ShaderName.G2D));
			uploadProjectionMatrix(context3d);
			if(hasOpaqueDrawUnits){
				context3d.clear(0, 0, 0, 0, 1, 0, Context3DClearMask.DEPTH);
				context3d.setBlendFactor(BlendMode.NORMAL);
				context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
//				drawImp(context3d, collector.opaqueQuadList);
				drawImp(context3d, collector.opaqueQuadHead);
			}
			if(hasBlendDrawUnits){
				const depthPassCompareMode:String = hasOpaqueDrawUnits ? Context3DCompareMode.LESS_EQUAL : Context3DCompareMode.ALWAYS;
				context3d.setDepthTest(false, depthPassCompareMode);
//				drawImp(context3d, collector.blendQuadList);
				drawImp(context3d, collector.blendQuadHead);
				context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
				context3d.setBlendFactor(BlendMode.NORMAL);
			}
		}
		
		private function drawImp(context3d:IGpuContext, drawUnit:DrawUnit2D):void
//		private function drawImp(context3d:IGpuContext, drawUnitList:Vector.<DrawUnit2D>):void
		{
			var currentGpuTexture:IGpuTexture;
			var currentBlendMode:BlendMode;
			
//			for each(var drawUnit:DrawUnit2D in drawUnitList)
			for(; drawUnit; drawUnit=drawUnit.next)
			{
				var gpuTexture:IGpuTexture = drawUnit.texture.gpuTexture;
				var blendMode:BlendMode = drawUnit.target.blendMode;
				
				if(null == currentGpuTexture){
					currentGpuTexture = gpuTexture;
				}
				if(null == currentBlendMode){
					context3d.setBlendFactor(blendMode);
					currentBlendMode = blendMode;
				}
				
				if(gpuTexture != currentGpuTexture){
					quadBatch.draw(context3d, currentGpuTexture);
					quadBatch.clear();
					currentGpuTexture = gpuTexture;
				}
				
				if(blendMode != currentBlendMode){
					quadBatch.draw(context3d, currentGpuTexture);
					quadBatch.clear();
					currentBlendMode = blendMode;
					context3d.setBlendFactor(blendMode);
				}
				
				drawUnit.getVertexData(sharedVertexData);
				quadBatch.addQuad(sharedVertexData);
			}
			
			quadBatch.draw(context3d, currentGpuTexture);
			quadBatch.clear();
		}
		
		static private const sharedVertexData:VertexData = new VertexData();
	}
}