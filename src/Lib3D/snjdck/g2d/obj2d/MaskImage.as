package snjdck.g2d.obj2d
{
	import flash.geom.Matrix;
	import flash.lang.IDisposable;
	
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g2d.impl.Texture2D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.render.GpuRender;
	
	[Deprecated]
	class MaskImage extends Image implements IDisposable
	{
		private var renderTarget:GpuRenderTarget
		private var scene2d:DisplayObjectContainer2D;
		
		public function MaskImage(source:Texture2D, mask:Texture2D)
		{
			renderTarget = new GpuRenderTarget(source.width, source.height);
			renderTarget.backgroundColor = 0x00000000;
			
			scene2d = new DisplayObjectContainer2D();
			
			var originImage:Image = new Image(source);
			var maskImage:Image = new Image(mask);
			/*
			originImage.blendMode = BlendMode.MASK;
			maskImage.blendMode = BlendMode.NORMAL;
			*/
			scene2d.addChild(maskImage);
			scene2d.addChild(originImage);
			
			super(new Texture2D(renderTarget));
		}
		
		public function dispose():void
		{
			texture.gpuTexture.dispose();
		}
		
		override public function onUpdate(timeElapsed:int, parentWorldMatrix:Matrix, parentWorldAlpha:Number):void
		{
			super.onUpdate(timeElapsed, parentWorldMatrix, parentWorldAlpha);
			scene2d.onUpdate(timeElapsed, null, 1);
		}
		
		override public function draw(render:GpuRender, context3d:GpuContext):void
		{
			const prevRenderTarget:GpuRenderTarget = context3d.renderTarget;
			
			renderTarget.setRenderToSelfAndClear(context3d);
			render.drawScene2D(scene2d, context3d);
			
			context3d.renderTarget = prevRenderTarget;
			super.draw(render, context3d);
		}
	}
}