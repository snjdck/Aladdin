package f2d
{
	import flash.display.MovieClip;
	import lambda.apply;

	public function addFrameScriptOnce(mc:MovieClip, frameIndex:int, funcData:Object):void
	{
		addFrameScript(mc, frameIndex, function():void{
			addFrameScript(mc, frameIndex, null);
			apply(funcData);
		});
	}
}