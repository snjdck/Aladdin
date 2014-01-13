package f2d
{
	import flash.display.MovieClip;
	
	import math.truncate;

	/**
	 * @param frameIndex 第几帧, 1 <= frameIndex <= mc.totalFrames
	 */
	public function addFrameScript(mc:MovieClip, frameIndex:int, code:Function):void
	{
		frameIndex = truncate(frameIndex, 1, mc.totalFrames);
		mc.addFrameScript(frameIndex-1, code);
	}
}