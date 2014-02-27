package org.xmlui.alignment
{
	import flash.support.Layout;
	
	import org.xmlui.IAlign;
	
	internal class CenterAlign extends Align implements IAlign
	{
		public function CenterAlign(offset:Number=0)
		{
			super(offset);
		}
		
		public function update(target:Object):void
		{
			Layout.CenterViewX(target, target.parent.width, offset);
		}
	}
}