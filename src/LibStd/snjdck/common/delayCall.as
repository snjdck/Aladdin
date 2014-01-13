package snjdck.common
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import lambda.apply;

	/**
	 * @param callback 回调
	 * @param delay 延迟时间(单位:秒)
	 * @param repeatCount 重复次数, if repeatCount <= 0, repeat forever
	 * @return stopHandler
	 */
	public function delayCall(callback:Object, delay:Number=0, repeatCount:int=1):Function
	{
		var timer:Timer = timerPool.getObjectOut();
		
		timer.delay = 1000 * delay;
		timer.repeatCount = repeatCount;
		
		timer.addEventListener(TimerEvent.TIMER, __onTimer);
		timer.start();
		
		function __onTimer(evt:TimerEvent):void
		{
			if(timer.repeatCount > 0 && timer.currentCount >= timer.repeatCount){
				stopHandler();
			}
			apply(callback);
		}
		
		function stopHandler():void{
			if(timer){
				timer.removeEventListener(TimerEvent.TIMER, __onTimer);
				timer.reset();//stop and set currentCount to 0
				timerPool.setObjectIn(timer);
				timer = null;
			}
		}
		
		return stopHandler;
	}
}

import flash.utils.Timer;

import stdlib.components.ObjectPool;

const timerPool:ObjectPool = new ObjectPool(Timer, [1000, 1]);