package f2d
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import lambda.apply;

	/**
	 * @param pts Array(or Vector) of objects(which contains x and y property,like Point)
	 */
	public function moveWithPath(target:DisplayObject, speed:Number, pts:Object, callback:Object, fromIndex:int=0):void
	{
		if(fromIndex >= pts.length){
			apply(callback);
			return;
		}
		
		const pt:Object = pts[fromIndex];
		
		const dx:Number = pt.x - target.x;
		const dy:Number = pt.y - target.y;
		const angle:Number = Math.atan2(dy, dx);
		const speedX:Number = speed * Math.cos(angle);
		const speedY:Number = speed * Math.sin(angle);
		
		const totalStep:int = Math.ceil(Math.sqrt(dx*dx+dy*dy)/speed);
		var step:int = 0;
		
		target.rotation = angle * 180 / Math.PI;
		target.addEventListener(Event.ENTER_FRAME, function(evt:Event):void
		{
			if(++step >= totalStep){
				target.x = pt.x;
				target.y = pt.y;
				target.removeEventListener(evt.type, arguments.callee);
				moveWithPath(target, speed, pts, callback, fromIndex+1);
			}else{
				target.x += speedX;
				target.y += speedY;
			}
		});
	}
}