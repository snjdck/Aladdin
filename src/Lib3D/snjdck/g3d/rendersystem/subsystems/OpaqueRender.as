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
		private var depthCubeShaderName:String;
		private var heroShaderName:String;
		
		public function OpaqueRender(shaderName:String)
		{
			this.shaderName = shaderName;
			geometryShaderName = shaderName + "_geom";
			depthShaderName = shaderName + "_depth";
			depthCubeShaderName = shaderName + "_depth_cube";
			heroShaderName = shaderName + "_hero";
		}
		
		public function activePass(context3d:GpuContext, renderType:int):void
		{
			if(renderType == RenderType.HERO_PASS){
				context3d.setDepthTest(false, Context3DCompareMode.GREATER);
			}else{
				context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			}
			context3d.setCulling(Context3DTriangleFace.BACK);
			context3d.blendMode = BlendMode.NORMAL;
			if(renderType == RenderType.MATERIAL){
				context3d.program = AssetMgr.Instance.getProgram(shaderName);
			}else if(renderType == RenderType.GEOMETRY){
				context3d.program = AssetMgr.Instance.getProgram(geometryShaderName);
			}else if(renderType == RenderType.DEPTH){
				context3d.program = AssetMgr.Instance.getProgram(depthShaderName);
			}else if(renderType == RenderType.DEPTH_CUBE){
				context3d.program = AssetMgr.Instance.getProgram(depthCubeShaderName);
			}else if(renderType == RenderType.HERO_PASS){
				context3d.program = AssetMgr.Instance.getProgram(heroShaderName);
			}
		}
		
		public function render(context3d:GpuContext, item:Object):void
		{
			var drawUnit:IDrawUnit3D = item as IDrawUnit3D;
			drawUnit.draw(context3d);
		}
	}
}