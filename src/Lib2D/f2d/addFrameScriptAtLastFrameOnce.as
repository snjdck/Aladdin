package f2d
{
	import flash.display.MovieClip;

	public function addFrameScriptAtLastFrameOnce(mc:MovieClip, funcData:Object):void
	{
		addFrameScriptOnce(mc, mc.totalFrames, funcData);
	}
}