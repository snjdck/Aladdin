package snjdck.g3d.obj3d
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.lang.IDisposable;
	
	import snjdck.g2d.obj2d.Image;
	import snjdck.g2d.texture.Texture2D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.ViewPort3D;
	import snjdck.gpu.asset.GpuAssetFactory;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.IGpuTexture;
	
	use namespace ns_g3d;

	public class Pic3D extends Image implements IDisposable
	{
		private var viewPort:ViewPort3D;
		
		public function Pic3D(width:int, height:int, object3d:Object3D)
		{
//			var tex:IGpuTexture = GpuAssetFactory.CreateGpuTexture2(new BitmapData(100, 100, true, 0xFFFF0000));
			var renderTarget:GpuRenderTarget = new GpuRenderTarget(width, height);
			renderTarget.backgroundColor = 0x8800FF00;
			viewPort = new ViewPort3D(renderTarget);
			viewPort.scene3d.addChild(object3d);
//			var textImage:Image = new Image(new Texture2D(tex));
//			textImage.x = 100;
//			textImage.y = 100;
//			viewPort.scene2d.addChild(textImage);
			super(new Texture2D(renderTarget));
		}
		
		public function dispose():void
		{
			texture.gpuTexture.dispose();
		}
		/*
		public function getCamera():Camera3D
		{
			return viewPort.camera;
		}
		*/
		override public function onUpdate(timeElapsed:int, parentWorldMatrix:Matrix, parentWorldAlpha:Number):void
		{
			super.onUpdate(timeElapsed, parentWorldMatrix, parentWorldAlpha);
			viewPort.update(timeElapsed);
		}
		
		override public function draw(render:GpuRender, context3d:GpuContext):void
		{
//			const prevRenderTarget:GpuRenderTarget = context3d.renderTarget;
//			viewPort.draw(context3d, render);
//			context3d.renderTarget = prevRenderTarget;
//			render.r2d.uploadProjectionMatrix(context3d);
			super.draw(render, context3d);
		}
		
		override public function preDrawRenderTargets(context3d:GpuContext, render:GpuRender):void
		{
			super.preDrawRenderTargets(context3d, render);
			viewPort.draw(context3d, render);
		}
	}
}