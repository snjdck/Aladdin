package org.xmlui.alignment
{
	import org.xmlui.IAlign;
	
	internal class BottomAlign extends Align implements IAlign
	{
		public function BottomAlign(offset:Number=0)
		{
			super(offset);
		}
		
		public function update(target:Object):void
		{
			target.y = target.parent.height - target.height + offset;
		}
	}
}