package bound2d
{
	import flash.geom.Rectangle;

	public function union(a:Rectangle, b:Rectangle, result:Rectangle):void
	{
		if(a.isEmpty()){
			if(result != b){
				result.copyFrom(b);
			}
			return;
		}
		if(b.isEmpty()){
			if(result != a){
				result.copyFrom(a);
			}
			return;
		}
		var minX:Number = Math.min(a.x, b.x);
		var minY:Number = Math.min(a.y, b.y);
		var maxX:Number = Math.max(a.x + a.width, b.x + b.width);
		var maxY:Number = Math.max(a.y + a.height, b.y + b.height);
		result.x = minX;
		result.y = minY;
		result.width = maxX - minX;
		result.height = maxY - minY;
	}
}