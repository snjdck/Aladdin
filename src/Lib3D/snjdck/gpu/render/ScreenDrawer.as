package snjdck.gpu.render
{
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.render.instance.EmptyInstanceData;
	import snjdck.gpu.render.instance.InstanceRender;
	
	public class ScreenDrawer
	{
		static public function Draw(context3d:GpuContext):void
		{
			InstanceRender.Instance.drawQuad(context3d, EmptyInstanceData.Instance, 1);
		}
	}
}