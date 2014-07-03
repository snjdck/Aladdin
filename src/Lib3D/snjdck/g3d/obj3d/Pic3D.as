package snjdck.g3d.obj3d
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.lang.IDisposable;
	
	import snjdck.g2d.obj2d.Image;
	import snjdck.g2d.texture.Texture2D;
	import snjdck.g3d.ns_g3d;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.GpuAssetFactory;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenterTarget;
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.ViewPort3D;
	
	use namespace ns_g3d;

	public class Pic3D extends Image implements IDisposable
	{
		private var viewPort:ViewPort3D;
		
		public function Pic3D(width:int, height:int, object3d:Object3D)
		{
			var tex:IGpuTexture = GpuAssetFactory.CreateGpuTexture2(new BitmapData(100, 100, true, 0xFFFF0000));
			viewPort = new ViewPort3D(width, height);
			viewPort.backgroundColor = 0x8800FF00;
			viewPort.scene3d.addChild(object3d);
			var textImage:Image = new Image(new Texture2D(tex));
			textImage.opaque = true;
			textImage.x = 100;
			textImage.y = 100;
			viewPort.scene2d.addChild(textImage);
			super(new Texture2D(viewPort));
		}
		
		public function dispose():void
		{
			viewPort.dispose();
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
		
		override public function preDrawRenderTargets(context3d:GpuContext):void
		{
			super.preDrawRenderTargets(context3d);
			viewPort.draw(context3d);
		}
	}
}