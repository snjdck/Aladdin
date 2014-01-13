package snjdck.agalc.arithmetic
{
	import array.has;

	public class TempRegFactory implements ITempRegFactory
	{
		private var allRegs:Array;
		private var validRegs:Array;
		
		public function TempRegFactory(tempRegs:Array)
		{
			allRegs = tempRegs;
			validRegs = allRegs.slice();
		}
		
		public function isTempReg(reg:String):Boolean
		{
			var result:Boolean = true;
			result &&= (reg.indexOf("t") == 1);
			result &&= array.has(allRegs, reg.split(".")[0]);
			return result;
		}
		
		public function hasValidTempReg():Boolean
		{
			return validRegs.length > 0;
		}
		
		public function retrieveTempReg():String
		{
			return validRegs.pop();
		}
		
		public function restoreTempReg(reg:String):void
		{
			validRegs.push(reg);
		}
	}
}