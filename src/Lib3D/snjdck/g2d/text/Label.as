package snjdck.g2d.text
{
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuProgram;
	import snjdck.gpu.support.QuadRender;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g2d;
	
	public class Label extends DisplayObject2D
	{
		public var text:String;
		
		public function Label()
		{
			width = 100;
			height = 100;
			textColor[1] = 1;
		}
		
		override public function hasVisibleArea():Boolean
		{
			return super.hasVisibleArea() && Boolean(text);
		}
		
		override protected function onDraw(render2d:Render2D, context3d:GpuContext):void
		{
			const prevProgram:GpuProgram = context3d.program;
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.TEXT_2D);
			
			context3d.setFc(0, textColor);
			TextRender.Instance.prepareVc(render2d, prevWorldMatrix);
			TextRender.Instance.drawText(context3d, text, width, height);
			
			context3d.program = prevProgram;
			QuadRender.Instance.drawBegin(context3d);
		}
		
		private const textColor:Vector.<Number> = new Vector.<Number>(4, true);
	}
}