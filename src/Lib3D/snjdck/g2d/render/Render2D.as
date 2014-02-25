package snjdck.g2d.render
{
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Matrix;
	
	import matrix33.toBuffer;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.IRender;
	import snjdck.g2d.core.ITexture2D;
	import snjdck.g2d.support.QuadBatch;
	import snjdck.g2d.support.VertexData;
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.asset.helper.AssetMgr;
	import snjdck.g3d.asset.helper.ShaderName;
	import snjdck.g3d.ns_g3d;
	
	use namespace ns_g3d;

	public class Render2D implements IRender
	{
		private const quadBatch:QuadBatch = new QuadBatch();
		
		private const projectionMatrix:Matrix = new Matrix();
		private const projectionMatrixBuffer:Vector.<Number> = new Vector.<Number>(8, true);
		
		public function Render2D()
		{
		}
		
		public function setScreenSize(width:int, height:int):void
		{
			projectionMatrix.setTo(2.0/width, 0, 0, -2.0/height, -1.0, 1.0);
			matrix33.toBuffer(projectionMatrix, projectionMatrixBuffer);
		}
		
		public function uploadProjectionMatrix(context3d:IGpuContext):void
		{
			context3d.setVc(0, projectionMatrixBuffer, 2);
		}
		
		public function drawScreen(context3d:IGpuContext):void
		{
			vertexMatrix.identity();
			vertexMatrix.scale(2, -2);
			vertexMatrix.translate(-1, 1);
			
			vertexData.reset();
			vertexData.transformPosition(vertexMatrix);
			
			context3d.setProgram(AssetMgr.Instance.getProgram(ShaderName.G2D_DRAW_SCREEN));
			
			quadBatch.addQuad(vertexData);
			quadBatch.draw(context3d, null);
			quadBatch.clear();
			
			context3d.setProgram(AssetMgr.Instance.getProgram(ShaderName.G2D));
		}
		
		public function draw(context3d:IGpuContext, target:IDisplayObject2D, texture:ITexture2D):void
		{
			context3d.setProgram(AssetMgr.Instance.getProgram(ShaderName.G2D));

			context3d.setBlendFactor(target.blendMode);
			context3d.setDepthTest(false, Context3DCompareMode.ALWAYS);
			
			getVertexData(target, texture);
			quadBatch.addQuad(vertexData);
			quadBatch.draw(context3d, texture.gpuTexture);
			quadBatch.clear();
		}
		
		static private function getVertexData(target:IDisplayObject2D, texture:ITexture2D):void
		{
			vertexMatrix.identity();
			vertexMatrix.scale(target.width, target.height);
			
			vertexData.reset();
			vertexData.transformPosition(vertexMatrix);
			vertexData.color = target.color;
			vertexData.alpha = target.worldAlpha;
			texture.adjustVertexData(vertexData);
			vertexData.transformPosition(target.worldMatrix);
			vertexData.z = 0;
		}
		
		static private const vertexData:VertexData = new VertexData();
		static private const vertexMatrix:Matrix = new Matrix();
	}
}