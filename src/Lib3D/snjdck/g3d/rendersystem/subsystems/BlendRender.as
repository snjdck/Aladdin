package snjdck.g3d.rendersystem.subsystems
{
	import flash.display3D.Context3DCompareMode;
	
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.rendersystem.ISystem;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	
	internal class BlendRender implements ISystem
	{
		public function BlendRender()
		{
		}
		
		public function onDrawBegin(context3d:GpuContext):void
		{
			context3d.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
		}
		
		public function render(context3d:GpuContext, item:Object):void
		{
			var drawUnit:IDrawUnit3D = item as IDrawUnit3D;
			context3d.program = AssetMgr.Instance.getProgram(drawUnit.shaderName);
			context3d.blendMode = drawUnit.blendMode;
			drawUnit.draw(context3d);
		}
	}
}