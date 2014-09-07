package snjdck.g2d.render
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.texture.Texture2D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.helper.AssetMgr;
	import snjdck.gpu.asset.helper.ShaderName;
	import snjdck.gpu.projection.Projection2D;
	import snjdck.gpu.render.IRender;

	final public class Render2D implements IRender
	{
		private const projectionStack:Vector.<Projection2D> = new Vector.<Projection2D>();
		private var projectionIndex:int;
		
		private var gpuVertexBuffer:GpuVertexBuffer;
		private var gpuIndexBuffer:GpuIndexBuffer;
		private var isGpuBufferInited:Boolean;
		
		public function Render2D(){}
		
		private function get projection():Projection2D
		{
			return projectionStack[projectionIndex];
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
		
		public function pushScreen(width:int, height:int):void
		{
			++projectionIndex;
			while(projectionStack.length <= projectionIndex){
				projectionStack.push(new Projection2D());
			}
			projection.resize(width, height);
		}
		
		public function popScreen():void
		{
			projection.offset(0, 0);
			--projectionIndex;
		}
		
		public function drawBegin(context3d:GpuContext):void
		{
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.IMAGE);
			context3d.blendMode = BlendMode.ALPHAL;
			context3d.setDepthTest(false, Context3DCompareMode.ALWAYS);
			initGpuBuffer(context3d);
			context3d.setVertexBufferAt(0, gpuVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
		}
		
		public function drawImage(context3d:GpuContext, target:IDisplayObject2D, texture:Texture2D):void
		{
			var worldMatrix:Matrix = target.worldMatrix;
			var frameMatrix:Matrix = texture.frameMatrix;
			var uvMatrix:Matrix = texture.uvMatrix;
			
			constData[4] = worldMatrix.a;
			constData[5] = worldMatrix.c;
			constData[6] = target.width;
			constData[7] = worldMatrix.tx;
			
			constData[8] = worldMatrix.b;
			constData[9] = worldMatrix.d;
			constData[10] = target.height;
			constData[11] = worldMatrix.ty;
			
			constData[12] = frameMatrix.a;
			constData[13] = frameMatrix.d;
			constData[14] = frameMatrix.tx;
			constData[15] = frameMatrix.ty;
			
			constData[16] = uvMatrix.a;
			constData[17] = uvMatrix.d;
			constData[18] = uvMatrix.tx;
			constData[19] = uvMatrix.ty;
			
			projection.upload(constData);
			
			context3d.setVc(0, constData, 5);
			context3d.setTextureAt(0, texture.gpuTexture);
			context3d.drawTriangles(gpuIndexBuffer);
		}
		
		public function drawTexture(context3d:GpuContext, texture:IGpuTexture, textureX:Number=0, textureY:Number=0):void
		{
			constData[4] = texture.width;
			constData[5] = texture.height;
			constData[6] = textureX;
			constData[7] = textureY;
			
			projection.upload(constData);
			
			context3d.setVc(0, constData, 2);
			context3d.setTextureAt(0, texture);
			context3d.drawTriangles(gpuIndexBuffer);
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
		
		private const constData:Vector.<Number> = new Vector.<Number>(20, true);
	}
}