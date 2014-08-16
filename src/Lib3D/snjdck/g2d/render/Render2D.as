package snjdck.g2d.render
{
	import flash.display3D.Context3DCompareMode;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.IRender;
	import snjdck.g2d.core.ITexture2D;
	import snjdck.g2d.support.QuadBatch;
	import snjdck.g2d.support.VertexData;
	import snjdck.g3d.ns_g3d;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.helper.AssetMgr;
	import snjdck.gpu.asset.helper.ShaderName;
	
	use namespace ns_g3d;

	public class Render2D implements IRender
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
		
		public function drawScreen(context3d:GpuContext):void
		{
			context3d.setProgram(AssetMgr.Instance.getProgram(ShaderName.G2D_DRAW_SCREEN));
			
			vertexData.reset(-1, -1, 2, 2);
			quadBatch.addQuad(vertexData);
			quadBatch.draw(context3d);
			quadBatch.clear();
			
			context3d.setProgram(AssetMgr.Instance.getProgram(ShaderName.G2D));
		}
		
		public function render(scene2d:IDisplayObject2D, context3d:GpuContext):void
		{
			drawBegin(context3d);
			scene2d.draw(this, context3d);
			drawEnd(context3d);
		}
		
		public function drawBegin(context3d:GpuContext):void
		{
			context3d.setProgram(AssetMgr.Instance.getProgram(ShaderName.G2D));
			context3d.setDepthTest(false, Context3DCompareMode.ALWAYS);
		}
		
		public function drawEnd(context3d:GpuContext):void
		{
			quadBatch.draw(context3d);
			quadBatch.clear();
			
			currentGpuTexture = null;
		}
		
		public function draw(context3d:GpuContext, target:IDisplayObject2D, texture:ITexture2D):void
		{
			vertexData.reset(0, 0, target.width, target.height);
			texture.adjustVertexData(vertexData);
			vertexData.transformPosition(target.worldMatrix);
			vertexData.color = target.color;
			vertexData.alpha = target.worldAlpha;
			
			context3d.setBlendFactor(target.blendMode);
			
			if(texture.gpuTexture == currentGpuTexture){
				quadBatch.addQuad(vertexData);
			}else{
				if(currentGpuTexture != null){
					quadBatch.draw(context3d);
					quadBatch.clear();
				}
				
				currentGpuTexture = texture.gpuTexture;
				context3d.setTextureAt(0, currentGpuTexture);
				quadBatch.addQuad(vertexData);
			}
		}
		
		static private const vertexData:VertexData = new VertexData();
	}
}