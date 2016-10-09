package snjdck.g3d.rendersystem.subsystems
{
	import snjdck.g3d.rendersystem.RenderSystem;
	import snjdck.shader.ShaderName;

	public class RenderSystemFactory
	{
		static public function CreateRenderSystem():RenderSystem
		{
			var renderSystem:RenderSystem = new RenderSystem();
			renderSystem.regSystem(new OpaqueRender(ShaderName.STATIC_OBJECT), RenderPriority.STATIC_OBJECT);
			renderSystem.regSystem(new OpaqueRender(ShaderName.DYNAMIC_OBJECT), RenderPriority.SKELETON_OBJECT);
			renderSystem.regSystem(new OpaqueRender(ShaderName.BILLBOARD), RenderPriority.BILLBOARD);
			renderSystem.regSystem(new OpaqueRender(ShaderName.LINE_3D), RenderPriority.LINE_3D);
			renderSystem.regSystem(new TerrainRender(), RenderPriority.TERRAIN);
			renderSystem.regSystem(new BlendRender(), RenderPriority.BLEND);
			return renderSystem;
		}
	}
}