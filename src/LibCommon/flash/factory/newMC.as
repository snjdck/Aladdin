package flash.factory
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import lambda.apply;

	public function newMC(resName:String, stop:Boolean=true):*
	{
		var ui:Sprite = apply(resName);
		var mc:MovieClip = ui as MovieClip;
		if(mc && stop){
			mc.stop();
		}
		return ui;
	}
}