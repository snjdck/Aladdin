package snjdck.g3d.obj3d
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.lang.IDisposable;
	
	import snjdck.g2d.obj2d.Image;
	import snjdck.g2d.texture.Texture2D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.asset.IGpuTexture;
	import snjdck.g3d.asset.impl.GpuAssetFactory;
	import snjdck.g3d.asset.impl.GpuRenterTarget;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.core.ViewPort3D;
	
	use namespace ns_g3d;

	public class Pic3D extends Image implements IDisposable
	{
		private var renderTarget:GpuRenterTarget;
		private var viewPort:ViewPort3D;
		
		public function Pic3D(width:int, height:int, object3d:Object3D)
		{
			renderTarget = new GpuRenterTarget(width, height);
			renderTarget.backgroundColor = 0x8800FF00;
			var tex:IGpuTexture = GpuAssetFactory.CreateGpuTexture2(new BitmapData(100, 100, true, 0xFFFF0000));
			viewPort = new ViewPort3D(renderTarget);
			viewPort.scene3d.addChild(object3d);
			var textImage:Image = new Image(new Texture2D(tex));
			textImage.opaque = true;
			textImage.x = 100;
			textImage.y = 100;
			viewPort.scene2d.addChild(textImage);
			super(new Texture2D(renderTarget));
		}
		
		public function dispose():void
		{
			renderTarget.dispose();
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
		
		override public function preDrawRenderTargets(context3d:IGpuContext):void
		{
			super.preDrawRenderTargets(context3d);
			viewPort.draw(context3d);
		}
	}
}