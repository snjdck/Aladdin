package org.xmlui.alignment
{
	import f2d.layout.centerViewY;
	
	import org.xmlui.IAlign;
	
	internal class MiddleAlign extends Align implements IAlign
	{
		public function MiddleAlign(offset:Number=0)
		{
			super(offset);
		}
		
		public function update(target:Object):void
		{
			centerViewY(target, target.parent.height, offset);
		}
	}
}