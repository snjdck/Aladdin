package snjdck.g2d.render
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.ColorTransform;
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
	import snjdck.gpu.state.StateStack;
	import snjdck.gpu.support.QuadRender;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g2d;

	final public class Render2D
	{
		private const projectionStack:StateStack = new StateStack(Projection2D);
		private var projection:Projection2D;
		private const rawData:Vector.<Number> = new Vector.<Number>(28, true);
		private const constData:ConstData = new ConstData(rawData);
		
		public function Render2D(){}
		
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
		
		public function pushScreen(width:int, height:int, offsetX:Number=0, offsetY:Number=0):void
		{
			projectionStack.push();
			projection = projectionStack.state;
			projection.resize(width, height);
			projection.offset(offsetX, offsetY);
		}
		
		public function popScreen():void
		{
			projectionStack.pop();
			projection = projectionStack.state;
		}
		
		public function drawBegin(context3d:GpuContext):void
		{
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.IMAGE);
			context3d.blendMode = BlendMode.ALPHAL;
			context3d.setDepthTest(false, Context3DCompareMode.ALWAYS);
			context3d.setCulling(Context3DTriangleFace.NONE);
			QuadRender.Instance.drawBegin(context3d);
		}
		
		public function drawImage(context3d:GpuContext, target:DisplayObject2D, texture:ITexture2D, colorTransform:ColorTransform=null):void
		{
			copyProjectData(rawData);
			matrix33.toBuffer(target.worldTransform, rawData, 4);
			
			constData.copyMatrix(texture.frameMatrix, 12);
			constData.copyMatrix(texture.uvMatrix, 14);
			
			rawData[20] = target.width;
			rawData[21] = texture.width;
			rawData[22] = target.height;
			rawData[23] = texture.height;
			if(null == texture.scale9){
				constData.resetScale9();
			}else{
				copy(texture.scale9, rawData, 4, 0, 24);
			}
			
			context3d.setVc(0, rawData, 7);
			constData.copyColorTransform(colorTransform);
			context3d.setFc(0, rawData, 2);
			context3d.texture = texture.gpuTexture;
			
			QuadRender.Instance.drawTriangles(context3d, texture.scale9 != null);
		}
		
		public function drawLocalRect(context3d:GpuContext, worldMatrix:Matrix, x:Number, y:Number, width:Number, height:Number):void
		{
			copyProjectData(rawData);
			if(null == worldMatrix){
				constData.resetWorldMatrix();
			}else{
				matrix33.toBuffer(worldMatrix, rawData, 4);
			}
			constData.resetFrameMatrix();
			constData.resetUvMatrix();
			constData.resetScale9();
			constData.setRect(x, y, width, height);
			
			context3d.setVc(0, rawData, 7);
			QuadRender.Instance.drawTriangles(context3d);
		}
		
		public function drawWorldRect(context3d:GpuContext, x:Number, y:Number, width:Number, height:Number):void
		{
			drawLocalRect(context3d, null, x, y, width, height);
		}
		
		public function drawTexture(context3d:GpuContext, texture:IGpuTexture, textureX:Number=0, textureY:Number=0):void
		{
			context3d.texture = texture;
			drawWorldRect(context3d, textureX, textureY, texture.width, texture.height);
		}
		
		public function copyProjectData(output:Vector.<Number>):void
		{
			projection.upload(output);
		}
	}
}