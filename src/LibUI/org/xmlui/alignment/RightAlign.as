package org.xmlui.alignment
{
	import org.xmlui.IAlign;
	
	internal class RightAlign extends Align implements IAlign
	{
		public function RightAlign(offset:Number=0)
		{
			super(offset);
		}
		
		public function update(target:Object):void
		{
			target.x = target.parent.width - target.width + offset;
		}
	}
}