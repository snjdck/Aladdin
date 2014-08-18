package snjdck.g2d.obj2d
{
	import flash.geom.Matrix;
	import flash.lang.IDisposable;
	
	import snjdck.g2d.texture.Texture2D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenterTarget;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.ViewPort3D;
	
	[Deprecated]
	class MaskImage extends Image implements IDisposable
	{
		private var viewPort:ViewPort3D;
		
		public function MaskImage(source:Texture2D, mask:Texture2D)
		{
			viewPort = new ViewPort3D(source.width, source.height);
			viewPort.backgroundColor = 0x00000000;
			
			var originImage:Image = new Image(source);
			var maskImage:Image = new Image(mask);
			/*
			originImage.blendMode = BlendMode.MASK;
			maskImage.blendMode = BlendMode.NORMAL;
			*/
			viewPort.scene2d.addChild(maskImage);
			viewPort.scene2d.addChild(originImage);
			
			super(new Texture2D(viewPort));
		}
		
		public function dispose():void
		{
			viewPort.dispose();
		}
		
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