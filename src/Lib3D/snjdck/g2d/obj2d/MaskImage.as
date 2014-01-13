package snjdck.g2d.obj2d
{
	import flash.geom.Matrix;
	import flash.lang.IDisposable;
	
	import snjdck.g2d.texture.Texture2D;
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.asset.impl.GpuRenterTarget;
	import snjdck.g3d.core.BlendMode;
	import snjdck.g3d.core.ViewPort3D;
	
	public class MaskImage extends Image implements IDisposable
	{
		private var renderTarget:GpuRenterTarget;
		private var viewPort:ViewPort3D;
		
		public function MaskImage(source:Texture2D, mask:Texture2D)
		{
			renderTarget = new GpuRenterTarget(source.width, source.height);
			renderTarget.backgroundColor = 0x00000000;
			viewPort = new ViewPort3D(renderTarget);
			
			var originImage:Image = new Image(source);
			var maskImage:Image = new Image(mask);
			
			originImage.blendMode = BlendMode.MASK;
			maskImage.blendMode = BlendMode.NORMAL;
			
			viewPort.scene2d.addChild(maskImage);
			viewPort.scene2d.addChild(originImage);
			
			super(new Texture2D(renderTarget));
		}
		
		public function dispose():void
		{
			renderTarget.dispose();
		}
		
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