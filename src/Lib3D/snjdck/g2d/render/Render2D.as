package snjdck.g2d.render
{
	import flash.display3D.Context3DCompareMode;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.IRender;
	import snjdck.g2d.support.QuadBatch;
	import snjdck.g2d.support.VertexData;
	import snjdck.g3d.ns_g3d;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.helper.AssetMgr;
	import snjdck.gpu.asset.helper.ShaderName;
	
	use namespace ns_g3d;

	final public class Render2D implements IRender
	{
		private const projectionMatrix:Vector.<Number> = new Vector.<Number>(8, true);
		private const quadBatch:QuadBatch = new QuadBatch();
		
		private var currentGpuTexture:IGpuTexture;
		
		public function Render2D()
		{
			projectionMatrix[3] = -1.0;
			projectionMatrix[7] =  1.0;
		}
		
		public function setScreenSize(width:int, height:int):void
		{
			projectionMatrix[0] =  2.0 / width;
			projectionMatrix[5] = -2.0 / height;
		}
		
		public function uploadProjectionMatrix(context3d:GpuContext):void
		{
			context3d.setVc(0, projectionMatrix, 2);
		}
		
		public function drawBegin(context3d:GpuContext):void
		{
			context3d.setProgram(AssetMgr.Instance.getProgram(ShaderName.G2D));
			context3d.setDepthTest(false, Context3DCompareMode.ALWAYS);
			context3d.setBlendFactor(BlendMode.ALPHAL);
		}
		
		public function drawEnd(context3d:GpuContext):void
		{
			quadBatch.draw(context3d);
			quadBatch.clear();
			
			currentGpuTexture = null;
		}
		
		public function drawTexture(context3d:GpuContext, vertexData:VertexData, gpuTexture:IGpuTexture):void
		{
			if(gpuTexture != currentGpuTexture){
				drawEnd(context3d);
				context3d.setTextureAt(0, gpuTexture);
				currentGpuTexture = gpuTexture;
			}
			quadBatch.addQuad(vertexData);
		}
	}
}