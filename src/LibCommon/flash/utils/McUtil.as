package flash.utils
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.listenEventOnce;
	
	import lambda.apply;
	
	import math.truncate;
	
	final public class McUtil
	{
		/**
		 * @param frameIndex 第几帧, 1 <= frameIndex <= mc.totalFrames
		 */
		static public function AddFrameScript(mc:MovieClip, frameIndex:int, code:Function):void
		{
			frameIndex = truncate(frameIndex, 1, mc.totalFrames);
			mc.addFrameScript(frameIndex-1, code);
		}
		
		static public function AddFrameScriptOnce(mc:MovieClip, frameIndex:int, funcData:Object):void
		{
			AddFrameScript(mc, frameIndex, function():void{
				AddFrameScript(mc, frameIndex, null);
				apply(funcData);
			});
		}
		
		static public function AddFrameScriptAtLastFrame(mc:MovieClip, code:Function):void
		{
			AddFrameScript(mc, mc.totalFrames, code);
		}
		
		static public function AddFrameScriptAtLastFrameOnce(mc:MovieClip, funcData:Object):void
		{
			AddFrameScriptOnce(mc, mc.totalFrames, funcData);
		}
		
		static public function GotoAndStop(target:MovieClip, frame:Object, callback:Function=null):void
		{
			if(null != callback){
				listenEventOnce(target, Event.FRAME_CONSTRUCTED, callback);
			}
			target.gotoAndStop(frame);
		}
		
		/**
		 * movieclip_getChildren(mc, "fish_", 1, 2) => [mc(which name equals "fish_1"), mc(which name equals "fish_2")]
		 */
		static public function GetChildren(target:MovieClip, prefix:String, fromIndex:int, toIndex:int):Array
		{
			var children:Array = [];
			for(var i:int=fromIndex; i<=toIndex; i++){
				children.push(target[prefix+i]);
			}
			return children;
		}
	}
}