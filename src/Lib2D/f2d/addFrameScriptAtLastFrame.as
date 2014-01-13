package f2d
{
	import flash.display.MovieClip;

	public function addFrameScriptAtLastFrame(mc:MovieClip, code:Function):void
	{
		addFrameScript(mc, mc.totalFrames, code);
	}
}