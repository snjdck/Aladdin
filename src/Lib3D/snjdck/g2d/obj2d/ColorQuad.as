package snjdck.g2d.obj2d
{
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.GpuColor;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.shader.ShaderName;
	
	public class ColorQuad extends DisplayObject2D
	{
		public const color:GpuColor = new GpuColor();
		
		public function ColorQuad(rgba:uint=0xFF000000)
		{
			color.value = rgba;
		}
		
		override protected function onDraw(render2d:Render2D, context3d:GpuContext):void
		{
			context3d.program = AssetMgr.Instance.getProgram("color_quad");
			render2d.drawColorQuad(context3d, this, color);
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.IMAGE);
		}
	}
}