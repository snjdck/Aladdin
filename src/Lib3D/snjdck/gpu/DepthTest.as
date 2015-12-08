package snjdck.gpu
{
	import flash.display3D.Context3DCompareMode;
	
	import string.replace;

	final public class DepthTest
	{
		public var writeMask:Boolean;
		public var passCompareMode:String;
		
		public function DepthTest()
		{
			reset();
		}
		
		public function reset():void
		{
			writeMask = true;
			passCompareMode = Context3DCompareMode.LESS_EQUAL;
		}
		
		public function setTo(depthWriteMask:Boolean, depthPassCompareMode:String):void
		{
			writeMask = depthWriteMask;
			passCompareMode = depthPassCompareMode;
		}
		
		public function copyFrom(other:DepthTest):void
		{
			writeMask = other.writeMask;
			passCompareMode = other.passCompareMode;
		}
		
		public function equals(depthWriteMask:Boolean, depthPassCompareMode:String):Boolean
		{
			return writeMask == depthWriteMask && passCompareMode == depthPassCompareMode;
		}
		
		public function toString():String
		{
			return replace("[DepthTest(writeMask=${0}, passCompareMode=${1})]", [writeMask, passCompareMode]);
		}
	}
}