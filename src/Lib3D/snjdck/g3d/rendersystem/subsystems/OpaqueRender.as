package snjdck.g3d.rendersystem.subsystems
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.rendersystem.ISystem;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	
	internal class OpaqueRender implements ISystem
	{
		private var shaderName:String;
		private var geometryShaderName:String;
		private var depthShaderName:String;
		
		public function OpaqueRender(shaderName:String)
		{
			this.shaderName = shaderName;
			geometryShaderName = shaderName + "_geom";
			depthShaderName = shaderName + "_depth";
		}
		
		public function activePass(context3d:GpuContext, passIndex:int):void
		{
			context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			context3d.blendMode = BlendMode.NORMAL;
			context3d.setCulling(Context3DTriangleFace.BACK);
			if(passIndex == RenderPass.MATERIAL_PASS){
				context3d.program = AssetMgr.Instance.getProgram(shaderName);
			}else if(passIndex == RenderPass.GEOMETRY_PASS){
				context3d.program = AssetMgr.Instance.getProgram(geometryShaderName);
			}else if(passIndex == RenderPass.DEPTH_PASS){
				context3d.program = AssetMgr.Instance.getProgram(depthShaderName);
				
			}
		}
		
		public function render(context3d:GpuContext, item:Object):void
		{
			var drawUnit:IDrawUnit3D = item as IDrawUnit3D;
			drawUnit.draw(context3d);
		}
	}
}