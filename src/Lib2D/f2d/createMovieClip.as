package f2d
{
	import flash.display.MovieClip;
	import lambda.apply;

	public function createMovieClip(resName:String, stop:Boolean=true):MovieClip
	{
		var mc:MovieClip = apply(resName);
		if(mc && stop){
			mc.stop();
		}
		return mc;
	}
}