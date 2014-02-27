package flash.support
{
	final public class Range
	{
		static public function Create(baseVal:Number, varVal:Number=0):Range
		{
			var halfVarVal:Number = 0.5 * varVal;
			return new Range(baseVal-halfVarVal, baseVal+halfVarVal);
		}
		
		private var beginValue:Number;
		private var valueChanged:Number;
		
		public function Range(beginValue:Number, endValue:Number)
		{
			setValue(beginValue, endValue);
		}
		
		private function get endValue():Number
		{
			return beginValue + valueChanged;
		}
		
		private function setValue(beginValue:Number, endValue:Number):void
		{
			this.beginValue = beginValue;
			this.valueChanged = endValue - beginValue;
		}
		
		public function getValue(ratio:Number):Number
		{
			return beginValue + valueChanged * ratio;
		}
		
		public function getRandowValue():Number
		{
			return getValue(Math.random());
		}
		
		public function flip():void
		{
			beginValue += valueChanged;
			valueChanged = -valueChanged;
		}
	}
}