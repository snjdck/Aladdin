package snjdck.g3d.obj3d
{
	import flash.geom.Matrix;
	import flash.lang.IDisposable;
	
	import snjdck.g2d.impl.Texture2D;
	import snjdck.g2d.obj2d.Image;
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.render.Render3D;
	import snjdck.gpu.View3D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	
	use namespace ns_g3d;

	public class Pic3D extends Image implements IDisposable
	{
		static private const camera3d:Camera3D = new Camera3D();
		private var renderTarget:GpuRenderTarget;
		private var object3d:Object3D;
		private var r3d:Render3D = new Render3D();
		
		public function Pic3D(width:int, height:int, object3d:Object3D)
		{
//			var tex:IGpuTexture = GpuAssetFactory.CreateGpuTexture2(new BitmapData(100, 100, true, 0xFFFF0000));
			renderTarget = new GpuRenderTarget(width, height);
			renderTarget.backgroundColor = 0x8800FF00;
			this.object3d = object3d;
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
		override public function onUpdate(timeElapsed:int):void
		{
			super.onUpdate(timeElapsed);
			object3d.onUpdate(timeElapsed);
		}
		
		override public function draw(render:Render2D, context3d:GpuContext):void
		{
			const prevRenderTarget:GpuRenderTarget = context3d.renderTarget;
			
			renderTarget.setRenderToSelfAndClear(context3d);
			r3d.draw(object3d, context3d);
			
			context3d.renderTarget = prevRenderTarget;
			
			render.drawBegin(context3d);
			super.draw(render, context3d);
		}
	}
}