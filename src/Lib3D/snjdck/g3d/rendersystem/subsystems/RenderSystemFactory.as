package snjdck.g3d.rendersystem.subsystems
{
	import snjdck.g3d.rendersystem.RenderSystem;

	public class RenderSystemFactory
	{
		static public function CreateRenderSystem():RenderSystem
		{
			var renderSystem:RenderSystem = new RenderSystem();
			renderSystem.regSystem(new StaticObjectRender(), RenderPriority.STATIC_OBJECT);
			renderSystem.regSystem(new SkeletonObjectRender(), RenderPriority.SKELETON_OBJECT);
			renderSystem.regSystem(new OpaqueRender(), RenderPriority.OPAQUE);
			renderSystem.regSystem(new OpaqueRender(), RenderPriority.OPAQUE);
			renderSystem.regSystem(new TerrainRender(), RenderPriority.TERRAIN);
			renderSystem.regSystem(new BlendRender(), RenderPriority.BLEND);
			return renderSystem;
		}
	}
}