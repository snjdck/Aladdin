package snjdck.g3d.rendersystem.subsystems
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.rendersystem.ISystem;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	
	internal class OpaqueRender extends ISystem
	{
		private var shaderName:String;
		private var geometryShaderName:String;
		
		public function OpaqueRender(shaderName:String)
		{
			this.shaderName = shaderName;
			geometryShaderName = shaderName + "_geom";
		}
		
		override protected function onGeometryPass(context3d:GpuContext):void
		{
			context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			context3d.blendMode = BlendMode.NORMAL;
			context3d.setCulling(Context3DTriangleFace.BACK);
			context3d.program = AssetMgr.Instance.getProgram(geometryShaderName);
		}
		
		override protected function onMaterialPass(context3d:GpuContext):void
		{
			context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			context3d.blendMode = BlendMode.NORMAL;
			context3d.setCulling(Context3DTriangleFace.BACK);
			context3d.program = AssetMgr.Instance.getProgram(shaderName);
		}
		
		override public function render(context3d:GpuContext, item:Object):void
		{
			var drawUnit:IDrawUnit3D = item as IDrawUnit3D;
			drawUnit.draw(context3d);
		}
	}
}