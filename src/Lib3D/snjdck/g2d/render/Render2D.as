package snjdck.g2d.render
{
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Matrix;
	
	import matrix33.toBuffer;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.ITexture2D;
	import snjdck.g2d.support.QuadBatch;
	import snjdck.g2d.support.VertexData;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.asset.helper.AssetMgr;
	import snjdck.g3d.asset.helper.ShaderName;
	
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
		
		public function uploadProjectionMatrix(context3d:IGpuContext):void
		{
			if(isProjectionMatrixDirty){
				matrix33.toBuffer(projectionMatrix, projectionMatrixBuffer);
				isProjectionMatrixDirty = false;
			}
			context3d.setVc(0, projectionMatrixBuffer, 2);
		}
		
		public function draw(context3d:IGpuContext, target:IDisplayObject2D, texture:ITexture2D):void
		{
			context3d.setProgram(AssetMgr.Instance.getProgram(ShaderName.G2D));

			context3d.setBlendFactor(target.blendMode);
			context3d.setDepthTest(false, Context3DCompareMode.ALWAYS);
			
			getVertexData(target, texture, sharedVertexData);
			quadBatch.addQuad(sharedVertexData);
			quadBatch.draw(context3d, texture.gpuTexture);
			quadBatch.clear();
		}
		
		static public function getVertexData(target:IDisplayObject2D, texture:ITexture2D, vertexData:VertexData):void
		{
			vertexData.reset();
			vertexMatrix.scale(target.width, target.height);
			vertexData.transformPosition(vertexMatrix);
			vertexMatrix.identity();
			vertexData.color = target.color;
			vertexData.alpha = target.worldAlpha;
			texture.adjustVertexData(vertexData);
			vertexData.transformPosition(target.worldMatrix);
			vertexData.z = 0;
		}
		
		static private const sharedVertexData:VertexData = new VertexData();
		static private const vertexMatrix:Matrix = new Matrix();
	}
}