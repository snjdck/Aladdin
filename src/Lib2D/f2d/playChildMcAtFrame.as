package f2d
{
	import flash.display.MovieClip;
	import lambda.apply;

	public function playChildMcAtFrame(target:MovieClip, frame:Object, mcName:String, funcData:Object):void
	{
		gotoAndStop(target, frame, function():void{
			addFrameScriptAtLastFrameOnce(target[mcName], function():void{
				(target[mcName] as MovieClip).stop();
				apply(funcData);
			});
		});
	}
}