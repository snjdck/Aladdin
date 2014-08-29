package snjdck.g2d.render
{
	import flash.display3D.Context3DCompareMode;
	
	import snjdck.g2d.core.IRender;
	import snjdck.g2d.support.QuadBatch;
	import snjdck.g2d.support.VertexData;
	import snjdck.g3d.ns_g3d;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.helper.AssetMgr;
	import snjdck.gpu.asset.helper.ShaderName;
	import snjdck.gpu.projection.Projection2D;
	
	use namespace ns_g3d;

	final public class Render2D implements IRender
	{
		private const projectionStack:Vector.<Projection2D> = new <Projection2D>[new Projection2D()];
		private var projectionIndex:int;
		
		private const quadBatch:QuadBatch = new QuadBatch();
		
		private var currentGpuTexture:IGpuTexture;
		
		public function Render2D()
		{
		}
		
		private function get projection():Projection2D
		{
			return projectionStack[projectionIndex];
		}
		
		public function setScreenSize(width:int, height:int):void
		{
			projection.resize(width, height);
		}
		
		public function offset(dx:Number=0, dy:Number=0):void
		{
			projection.offset(dx, dy);
		}
		
		public function get offsetX():Number
		{
			return projection.offsetX;
		}
		
		public function get offsetY():Number
		{
			return projection.offsetY;
		}
		
		public function uploadProjectionMatrix(context3d:GpuContext):void
		{
			projection.upload(context3d);
		}
		
		public function pushScreen():void
		{
			++projectionIndex;
			if(projectionStack.length <= projectionIndex){
				projectionStack.push(new Projection2D());
			}
		}
		
		public function popScreen():void
		{
			projection.offset(0, 0);
			--projectionIndex;
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