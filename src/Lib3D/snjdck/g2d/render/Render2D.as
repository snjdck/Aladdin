package snjdck.g2d.render
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix;
	
	import matrix33.toBuffer;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.ITexture2D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.GpuColor;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.helper.AssetMgr;
	import snjdck.gpu.asset.helper.ShaderName;
	import snjdck.gpu.matrixstack.MatrixStack2D;
	import snjdck.gpu.projectionstack.IProjectionStack;
	import snjdck.gpu.projectionstack.Projection2DStack;
	import snjdck.gpu.render.IRender;

	final public class Render2D implements IRender, IProjectionStack
	{
		private const projectionStack:Projection2DStack = new Projection2DStack();
		
		private const matrixStack:MatrixStack2D = new MatrixStack2D();
		
		private var gpuVertexBuffer:GpuVertexBuffer;
		private var gpuIndexBuffer:GpuIndexBuffer;
		private var isGpuBufferInited:Boolean;
		
		public function Render2D(){}
		
		public function offset(dx:Number=0, dy:Number=0):void
		{
			projectionStack.projection.offset(dx, dy);
		}
		
		public function get offsetX():Number
		{
			return projectionStack.projection.offsetX;
		}
		
		public function get offsetY():Number
		{
			return projectionStack.projection.offsetY;
		}
		
		public function pushScreen(width:int, height:int, offsetX:Number=0, offsetY:Number=0):void
		{
			projectionStack.pushScreen(width, height, offsetX, offsetY);
		}
		
		public function popScreen():void
		{
			projectionStack.popScreen();
		}
		
		public function pushMatrix(matrix:Matrix):void
		{
			matrixStack.pushMatrix(matrix);
		}
		
		public function popMatrix():void
		{
			matrixStack.popMatrix();
		}
		
		public function drawBegin(context3d:GpuContext):void
		{
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.IMAGE);
			context3d.blendMode = BlendMode.ALPHAL;
			context3d.setDepthTest(false, Context3DCompareMode.ALWAYS);
			initGpuBuffer(context3d);
			context3d.setVertexBufferAt(0, gpuVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setVc(127, VcConst, 1);
		}
		
		public function drawImage(context3d:GpuContext, target:IDisplayObject2D, texture:ITexture2D):void
		{
			var worldMatrix:Matrix = matrixStack.worldMatrix;
			var frameMatrix:Matrix = texture.frameMatrix;
			var uvMatrix:Matrix = texture.uvMatrix;
			
			matrix33.toBuffer(worldMatrix, constData, 4);
			
			constData[12] = frameMatrix.a * target.width;
			constData[13] = frameMatrix.d * target.height;
			constData[14] = frameMatrix.tx;
			constData[15] = frameMatrix.ty;
			
			constData[16] = uvMatrix.a;
			constData[17] = uvMatrix.d;
			constData[18] = uvMatrix.tx;
			constData[19] = uvMatrix.ty;
			
			projectionStack.projection.upload(constData);
			
			context3d.setVc(0, constData, 5);
			
			constData[0] = target.colorTransform.redMultiplier;
			constData[1] = target.colorTransform.greenMultiplier;
			constData[2] = target.colorTransform.blueMultiplier;
			constData[3] = target.colorTransform.alphaMultiplier;
			constData[4] = target.colorTransform.redOffset;
			constData[5] = target.colorTransform.greenOffset;
			constData[6] = target.colorTransform.blueOffset;
			constData[7] = target.colorTransform.alphaOffset;
			
			context3d.setFc(0, constData, 2);
			
			context3d.texture = texture.gpuTexture;
			context3d.drawTriangles(gpuIndexBuffer);
		}
		
		public function drawTexture(context3d:GpuContext, texture:IGpuTexture, textureX:Number=0, textureY:Number=0):void
		{
			constData[4] = texture.width;
			constData[5] = texture.height;
			constData[6] = textureX;
			constData[7] = textureY;
			
			projectionStack.projection.upload(constData);
			
			context3d.setVc(0, constData, 2);
			context3d.texture = texture;
			context3d.drawTriangles(gpuIndexBuffer);
		}
		
		public function drawParticleBegin(context3d:GpuContext, texture:IGpuTexture, blendMode:BlendMode):void
		{
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.PARTICLE_2D);
			context3d.blendMode = blendMode;
			
			projectionStack.projection.upload(constData);
			matrix33.toBuffer(matrixStack.worldMatrix, constData, 4);
			
			context3d.setVc(0, constData, 3);
			context3d.texture = texture;
		}
		
		public function drawParticle(context3d:GpuContext, localMatrix:Matrix, color:GpuColor):void
		{
			matrix33.toBuffer(localMatrix, constData);
			context3d.setVc(3, constData, 2);
			color.copyTo(constData);
			context3d.setFc(0, constData, 1);
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
		
		static private const VcConst:Vector.<Number> = new <Number>[0.5, 0, 0, 0];
	}
}