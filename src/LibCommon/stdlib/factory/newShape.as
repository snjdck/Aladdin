package stdlib.factory
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;

	public function newShape(parent:DisplayObjectContainer=null):Shape
	{
		var sp:Shape = new Shape();
		if(null != parent){
			parent.addChild(sp);
		}
		return sp;
	}
}