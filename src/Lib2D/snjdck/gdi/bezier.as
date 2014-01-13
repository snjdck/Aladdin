package snjdck.gdi
{
	import flash.geom.Point;
	
	import math.combination;

	public function bezier(t:Number, controlPts:Array, result:Point):void
	{
		const n:int = controlPts.length - 1;
		
		var x:Number = 0;
		var y:Number = 0;
		
		for(var i:int=0; i <= n; i++)
		{
			const blend:Number = combination(n, i) * Math.pow(t, i) * Math.pow(1-t, n-i);
			const pt:Point = controlPts[i];
			x += blend * pt.x;
			y += blend * pt.y;
		}
		
		result.x = x;
		result.y = y;
	}
}