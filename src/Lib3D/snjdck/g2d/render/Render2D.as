package snjdck.g2d.render
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix;
	
	import array.copy;
	
	import matrix33.toBuffer;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.core.ITexture2D;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.support.QuadRender;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g2d;

	final public class Render2D
	{
		private const projectionStack:Projection2DStack = new Projection2DStack();
		private const constData:Vector.<Number> = new Vector.<Number>(28, true);
		
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
		
		public function drawBegin(context3d:GpuContext):void
		{
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.IMAGE);
			context3d.blendMode = BlendMode.ALPHAL;
			context3d.setDepthTest(false, Context3DCompareMode.ALWAYS);
			context3d.setCulling(Context3DTriangleFace.NONE);
			QuadRender.Instance.drawBegin(context3d);
		}
		
		public function drawImage(context3d:GpuContext, target:DisplayObject2D, texture:ITexture2D):void
		{
			copyProjectData(constData);
			matrix33.toBuffer(target.prevWorldMatrix, constData, 4);
			
			copyMatrix(texture.frameMatrix, 12);
			copyMatrix(texture.uvMatrix, 14);
			
			constData[20] = target.width;
			constData[21] = texture.width;
			constData[22] = target.height;
			constData[23] = texture.height;
			if(null == texture.scale9){
				constData[24] = constData[25] = constData[26] = constData[27] = 0;
			}else{
				copy(texture.scale9, constData, 4, 0, 24);
			}
			
			context3d.setVc(0, constData, 7);
			context3d.texture = texture.gpuTexture;
			QuadRender.Instance.drawTriangles(context3d, texture.scale9 != null);
		}
		
		public function drawLocalRect(context3d:GpuContext, worldMatrix:Matrix, x:Number, y:Number, width:Number, height:Number):void
		{
			copyProjectData(constData);
			matrix33.toBuffer(worldMatrix, constData, 4);
			
			constData[12] = constData[13] = 1;
			constData[16] = x;
			constData[17] = y;
			
			constData[20] = constData[21] = width;
			constData[22] = constData[23] = height;
			constData[24] = constData[25] = constData[26] = constData[27] = 0;
			
			context3d.setVc(0, constData, 7);
			QuadRender.Instance.drawTriangles(context3d);
		}
		
		public function drawWorldRect(context3d:GpuContext, x:Number, y:Number, width:Number, height:Number):void
		{
			copyProjectData(constData);
			
			constData[4] = constData[9] = 
			constData[12] = constData[13] = constData[14] = constData[15] = 1;
			constData[5] = constData[6] = constData[7] = 
			constData[8] = constData[10] = constData[11] = 
			constData[18] = constData[19] = 
			constData[24] = constData[25] = constData[26] = constData[27] = 0;
			
			constData[16] = x;
			constData[17] = y;
			
			constData[20] = constData[21] = width;
			constData[22] = constData[23] = height;
			
			context3d.setVc(0, constData, 7);
			QuadRender.Instance.drawTriangles(context3d);
		}
		
		public function drawTexture(context3d:GpuContext, texture:IGpuTexture, textureX:Number=0, textureY:Number=0):void
		{
			context3d.texture = texture;
			drawWorldRect(context3d, textureX, textureY, texture.width, texture.height);
		}
		
		public function copyProjectData(output:Vector.<Number>):void
		{
			projectionStack.projection.upload(output);
		}
		
		private function copyMatrix(matrix:Matrix, toIndex:int):void
		{
			constData[toIndex  ] = matrix.a;
			constData[toIndex+1] = matrix.d;
			constData[toIndex+4] = matrix.tx;
			constData[toIndex+5] = matrix.ty;
		}
	}
}