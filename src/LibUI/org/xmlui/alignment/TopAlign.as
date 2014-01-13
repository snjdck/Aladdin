package org.xmlui.alignment
{
	import org.xmlui.IAlign;
	
	internal class TopAlign extends Align implements IAlign
	{
		public function TopAlign(offset:Number=0)
		{
			super(offset);
		}
		
		public function update(target:Object):void
		{
			target.y = offset;
		}
	}
}