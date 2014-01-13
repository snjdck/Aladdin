package stdlib.factory
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public function newSprite(parent:DisplayObjectContainer=null, name:String=null):Sprite
	{
		var sp:Sprite = new Sprite();
		
		sp.focusRect = false;
		sp.tabEnabled = false;
		sp.tabChildren = false;
		
		if(name){
			sp.name = name;
		}
		
		if(parent){
			parent.addChild(sp);
		}
		
		return sp;
	}
}