package snjdck.g2d.render
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.IRender;
	import snjdck.g2d.texture.Texture2D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.helper.AssetMgr;
	import snjdck.gpu.asset.helper.ShaderName;
	import snjdck.gpu.projection.Projection2D;

	final public class Render2D implements IRender
	{
		private const projectionStack:Vector.<Projection2D> = new <Projection2D>[new Projection2D()];
		private var projectionIndex:int;
		
		private var gpuVertexBuffer:GpuVertexBuffer;
		private var gpuIndexBuffer:GpuIndexBuffer;
		private var isGpuBufferInited:Boolean;
		
		public function Render2D(){}
		
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
			initGpuBuffer(context3d);
			context3d.setVertexBufferAt(0, gpuVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
		}
		
		public function drawImage(context3d:GpuContext, target:IDisplayObject2D, texture:Texture2D):void
		{
			var worldMatrix:Matrix = target.worldMatrix;
			var frameMatrix:Matrix = texture.frameMatrix;
			var uvMatrix:Matrix = texture.uvMatrix;
			
			constData[0] = worldMatrix.a;
			constData[1] = worldMatrix.c;
			constData[2] = target.width;
			constData[3] = worldMatrix.tx;
			
			constData[4] = worldMatrix.b;
			constData[5] = worldMatrix.d;
			constData[6] = target.height;
			constData[7] = worldMatrix.ty;
			
			constData[8] = frameMatrix.a;
			constData[9] = frameMatrix.d;
			constData[10] = frameMatrix.tx;
			constData[11] = frameMatrix.ty;
			
			constData[12] = uvMatrix.a;
			constData[13] = uvMatrix.d;
			constData[14] = uvMatrix.tx;
			constData[15] = uvMatrix.ty;
			
			context3d.setVc(1, constData, 4);
			context3d.setTextureAt(0, texture.gpuTexture);
			context3d.drawTriangles(gpuIndexBuffer, 0, 2);
		}
		
		public function drawTexture(context3d:GpuContext, texture:IGpuTexture, textureX:Number=0, textureY:Number=0):void
		{
			constData[0] = texture.width;
			constData[1] = texture.height;
			constData[2] = textureX;
			constData[3] = textureY;
			
			context3d.setVc(1, constData, 1);
			context3d.setTextureAt(0, texture);
			context3d.drawTriangles(gpuIndexBuffer, 0, 2);
		}
		
		private function initGpuBuffer(context3d:GpuContext):void
		{
			if(isGpuBufferInited){
				return;
			}
			isGpuBufferInited = true;
			
			gpuVertexBuffer = new GpuVertexBuffer(4, 2);
			gpuVertexBuffer.upload(new <Number>[0,0,1,0,1,1,0,1]);
			
			gpuIndexBuffer = new GpuIndexBuffer(6);
			gpuIndexBuffer.upload(new <uint>[0,1,2,0,2,3]);
		}
		
		private const constData:Vector.<Number> = new Vector.<Number>(16, true);
	}
}