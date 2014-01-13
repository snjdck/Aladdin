package org.xmlui.alignment
{
	import org.xmlui.IAlign;
	
	internal class LeftAlign extends Align implements IAlign
	{
		public function LeftAlign(offset:Number=0)
		{
			super(offset);
		}
		
		public function update(target:Object):void
		{
			target.x = offset;
		}
	}
}