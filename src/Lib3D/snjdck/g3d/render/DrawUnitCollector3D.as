package snjdck.g3d.render
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.asset.helper.ShaderName;
	import snjdck.g3d.core.BlendMode;
	import snjdck.g3d.core.IDrawUnitCollector;
	
	import stdlib.components.ObjectPool;
	
	use namespace ns_g3d;

	final public class DrawUnitCollector3D implements IDrawUnitCollector
	{
		static private const drawUnitPool:ObjectPool = new ObjectPool(DrawUnit3D);
		
		internal const opaqueList	:Vector.<DrawUnit3D> = new Vector.<DrawUnit3D>();
		internal const blendList	:Vector.<DrawUnit3D> = new Vector.<DrawUnit3D>();
//		internal const shadowList	:Vector.<DrawUnit3D> = new Vector.<DrawUnit3D>();
		/*
		internal const dynamicOpaqueList:Vector.<DrawUnit3D> = new Vector.<DrawUnit3D>();
		internal const dynamicBlendList	:Vector.<DrawUnit3D> = new Vector.<DrawUnit3D>();
		internal const staticOpaqueList	:Vector.<DrawUnit3D> = new Vector.<DrawUnit3D>();
		internal const staticBlendList	:Vector.<DrawUnit3D> = new Vector.<DrawUnit3D>();
		*/
		public function DrawUnitCollector3D()
		{
		}
		
		public function onFrameBegin():void
		{
//			trace("==begin==");
//			trace(opaqueList);
//			trace(blendList);
//			trace("-------------");
			opaqueList.sort(_sortDrawUnit3DList);
			blendList.sort(_sortDrawUnit3DList);
//			shadowList.sort(_sortDrawUnit3DList);
//			trace(opaqueList);
//			trace(blendList);
//			trace("==end==");
		}
		
		public function clear():void
		{
			while(opaqueList.length > 0){
				recoverDrawUnit(opaqueList.pop());
			}
			while(blendList.length > 0){
				recoverDrawUnit(blendList.pop());
			}
//			while(shadowList.length > 0){
//				recoverDrawUnit(shadowList.pop());
//			}
		}
		
		[Inline]
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
			if(canAddToOpaqueList(drawUnit)){
				opaqueList[opaqueList.length] = drawUnit;
			}else{
				blendList[blendList.length] = drawUnit;
			}
		}
		
		private function canAddToOpaqueList(drawUnit:DrawUnit3D):Boolean
		{
			if(ShaderName.OBJECT == drawUnit.shaderName){
				return BlendMode.NORMAL == drawUnit.blendFactor;
			}
			if(ShaderName.BONE_ANI == drawUnit.shaderName){
				
			}
			return false;
		}
		
		static private function _sortDrawUnit3DList(left:DrawUnit3D, right:DrawUnit3D):int
		{
			if(left.shaderName != right.shaderName){
				return (left.shaderName < right.shaderName) ? -1 : 1;
			}
			if(left.textureName == right.textureName){
				return 0;
			}
			return (left.textureName < right.textureName) ? -1 : 1;
		}
	}
}