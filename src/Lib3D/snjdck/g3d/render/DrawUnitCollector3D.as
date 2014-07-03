package snjdck.g3d.render
{
	import flash.support.ObjectPool;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.gpu.BlendMode;
	
	use namespace ns_g3d;

	final public class DrawUnitCollector3D
	{
		static private const drawUnitPool:ObjectPool = new ObjectPool(DrawUnit3D);
		
		ns_g3d const opaqueList:Vector.<DrawUnit3D> = new Vector.<DrawUnit3D>();
		ns_g3d const blendList:Vector.<DrawUnit3D> = new Vector.<DrawUnit3D>();
		
		public function DrawUnitCollector3D()
		{
		}
		
		public function clear():void
		{
			while(opaqueList.length > 0){
				recoverDrawUnit(opaqueList.pop());
			}
			while(blendList.length > 0){
				recoverDrawUnit(blendList.pop());
			}
		}
		
		private function recoverDrawUnit(drawUnit:DrawUnit3D):void
		{
			drawUnit.clear();
			drawUnitPool.setObjectIn(drawUnit);
		}
		
		public function getFreeDrawUnit():DrawUnit3D
		{
			return drawUnitPool.getObjectOut();
		}
		
		public function addDrawUnit(drawUnit:DrawUnit3D):void
		{
			if(drawUnit.blendFactor.equals(BlendMode.NORMAL)){
				opaqueList.push(drawUnit);
			}else{
				blendList.push(drawUnit);
			}
		}
	}
}