package snjdck.g3d.rendersystem
{
	import snjdck.g3d.rendersystem.subsystems.RenderPass;
	import snjdck.gpu.asset.GpuContext;

	public class ISystem
	{
		private const passHanderDict:Array = [];
		
		public function ISystem()
		{
			regPass(RenderPass.GEOMETRY_PASS, onGeometryPass);
			regPass(RenderPass.MATERIAL_PASS, onMaterialPass);
		}
		
		final protected function regPass(passIndex:int, handler:Function):void
		{
			passHanderDict[passIndex] = handler;
		}
		
		final internal function activePass(context3d:GpuContext, passIndex:int):void
		{
			var handler:Function = passHanderDict[passIndex];
			if(handler == null){
				return;
			}
			switch(handler.length){
				case 1:
					handler(context3d);
					break;
				case 2:
					handler(context3d, passIndex);
					break;
			}
		}
		
		protected function onGeometryPass(context3d:GpuContext):void
		{
		}
		
		protected function onMaterialPass(context3d:GpuContext):void
		{
		}
		
		public function render(context3d:GpuContext, item:Object):void
		{
		}
	}
}