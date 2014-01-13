package snjdck.agalc.arithmetic
{
	public interface ITempRegFactory
	{
		function isTempReg(reg:String):Boolean;
		function hasValidTempReg():Boolean;
		function retrieveTempReg():String;
		function restoreTempReg(reg:String):void;
	}
}