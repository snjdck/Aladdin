package snjdck.g3d.obj3d
{
	import flash.geom.Matrix;
	import flash.lang.IDisposable;
	
	import snjdck.g2d.impl.Texture2D;
	import snjdck.g2d.obj2d.Image;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.ViewPort3D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.render.GpuRender;
	
	use namespace ns_g3d;

	public class Pic3D extends Image implements IDisposable
	{
		private var renderTarget:GpuRenderTarget;
		private var viewPort:ViewPort3D;
		
		public function Pic3D(width:int, height:int, object3d:Object3D)
		{
//			var tex:IGpuTexture = GpuAssetFactory.CreateGpuTexture2(new BitmapData(100, 100, true, 0xFFFF0000));
			renderTarget = new GpuRenderTarget(width, height);
			renderTarget.backgroundColor = 0x8800FF00;
			viewPort = new ViewPort3D();
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
			const prevRenderTarget:GpuRenderTarget = context3d.renderTarget;
			
			renderTarget.setRenderToSelfAndClear(context3d);
			viewPort.draw(context3d, render);
			
			context3d.renderTarget = prevRenderTarget;
			super.draw(render, context3d);
		}
	}
}