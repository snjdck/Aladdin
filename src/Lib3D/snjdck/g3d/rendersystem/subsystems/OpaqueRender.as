package snjdck.g3d.rendersystem.subsystems
{
	import flash.display3D.Context3DCompareMode;
	
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.rendersystem.ISystem;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	
	internal class OpaqueRender implements ISystem
	{
		public function OpaqueRender()
		{
		}
		
		public function onDrawBegin(context3d:GpuContext):void
		{
			context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			context3d.blendMode = BlendMode.NORMAL;
		}
		
		public function render(context3d:GpuContext, item:Object):void
		{
			var drawUnit:IDrawUnit3D = item as IDrawUnit3D;
			context3d.program = AssetMgr.Instance.getProgram(drawUnit.shaderName);
			drawUnit.draw(context3d);
		}
	}
}