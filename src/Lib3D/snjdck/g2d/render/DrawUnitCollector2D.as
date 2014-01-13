package snjdck.g2d.render
{
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.impl.Collector2D;
	import snjdck.g3d.core.IDrawUnitCollector;
	
	import sorter.LinkListSorter;
	
	use namespace ns_g2d;

	final public class DrawUnitCollector2D extends Collector2D implements IDrawUnitCollector
	{
		internal var opaqueQuadHead:DrawUnit2D;
		internal var blendQuadHead:DrawUnit2D;
		
		public function DrawUnitCollector2D()
		{
		}
		
		override public function clear():void
		{
			super.clear();
			opaqueQuadHead = null;
			blendQuadHead = null;
		}
		
		override public function addDrawUnit(drawUnit:DrawUnit2D):void
		{
			super.addDrawUnit(drawUnit);
			if(drawUnit.target.opaque){
				drawUnit.next = opaqueQuadHead;
				opaqueQuadHead = drawUnit;
			}else{
				drawUnit.next = blendQuadHead;
				blendQuadHead = drawUnit;
			}
		}
		
		override public function onFrameBegin():void
		{
			super.onFrameBegin();
			opaqueQuadHead = LinkListSorter.Sort(opaqueQuadHead, _sortOpaqueQuadList);
			blendQuadHead = LinkListSorter.Sort(blendQuadHead, _sortBlendQuadList);
		}
		
		public function hasOpaqueDrawUnits():Boolean
		{
			return opaqueQuadHead != null;
		}
		
		public function hasBlendDrawUnits():Boolean
		{
			return blendQuadHead != null;
		}
		
		/** z值不可能相同 */
		static private function _sortOpaqueQuadList(left:DrawUnit2D, right:DrawUnit2D):int
		{
			return left.z < right.z ? -1 : 1;
		}
		
		/** z值不可能相同 */
		static private function _sortBlendQuadList(left:DrawUnit2D, right:DrawUnit2D):int
		{
			return left.z > right.z ? -1 : 1;
		}
	}
}