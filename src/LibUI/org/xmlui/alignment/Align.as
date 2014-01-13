package org.xmlui.alignment
{
	import org.xmlui.IAlign;

	public class Align
	{
		static public function Create(code:String, offset:Number):IAlign
		{
			switch(code)
			{
				case "left":	return new LeftAlign(offset);
				case "center":	return new CenterAlign(offset);
				case "right":	return new RightAlign(offset);
				case "top":		return new TopAlign(offset);
				case "middle":	return new MiddleAlign(offset);
				case "bottom":	return new BottomAlign(offset);
			}
			return null;
		}
		
		protected var offset:Number;
		
		public function Align(offset:Number=0)
		{
			this.offset = offset;
		}
	}
}