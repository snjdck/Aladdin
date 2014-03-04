package snjdck.effect.tween.impl
{
	import dict.deleteKey;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.support.Range;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import lambda.call;
	
	import snjdck.effect.tween.TweenEase;

	final public class Tween
	{
		static private const tweenDict:Object = new Dictionary();
		static private const evtSource:Shape = new Shape();
		static private var timestamp:int;
		
		static public function KillTweensOf(target:Object):void
		{
			delete tweenDict[target];
		}
		
		evtSource.addEventListener(Event.ENTER_FRAME, __onTick);
		timestamp = getTimer();
		
		static private function __onTick(evt:Event):void
		{
			var now:int = getTimer();
			var timeElapsed:int = now - timestamp;
			timestamp = now;
			
			for each(var tween:Tween in tweenDict){
				while(tween){
					tween.update(timeElapsed);
					tween = tween.nextSibling;
				}
			}
		}
		
		private var propInfoDict:Object;
		
		private var _target:Object;
		private var _position:int;
		private var _duration:int;
		private var ease:Function;
		private var props:Object;
		
		private var onUpdate:Object;
		private var onEnd:Object;
		
		private var nextSibling:Tween;
		
		/**
		 * 要实现循环缓动的话,可以设置 nextTask = this
		 */		
		public function Tween(target:Object, duration:int, props:Object=null, ease:Function=null, onEnd:Object=null, onUpdate:Object=null)
		{
			this._target = target;
			this._position = 0;
			this._duration = duration;
			this.ease = ease || TweenEase.Linear;
			this.props = props;
			
			this.onUpdate = onUpdate;
			this.onEnd = onEnd;
		}
		
		public function start():void
		{
			createPropInfoDict();
			
			if(running){
				return;
			}
			
			var tween:Tween = tweenDict[target];
			nextSibling = tween;
			tweenDict[target] = this;
			
			while(tween){
				for(var propName:String in propInfoDict){
					tween.delConflictProp(propName);
				}
				tween = tween.nextSibling;
			}
		}
		
		public function stop():void
		{
			var tween:Tween = tweenDict[target];
			
			if(null == tween){
				return;
			}
			
			if(this == tween){
				tweenDict[target] = nextSibling;
				return;
			}
			
			while(tween.nextSibling){
				if(this == tween.nextSibling){
					tween.nextSibling = nextSibling;
					return;
				}
				tween = tween.nextSibling;
			}
		}
		
		public function get running():Boolean
		{
			var tween:Tween = tweenDict[target];
			while(tween){
				if(this == tween){
					return true;
				}
				tween = tween.nextSibling;
			}
			return false;
		}
		
		public function get target():Object
		{
			return _target;
		}
		
		public function get position():int
		{
			return _position;
		}
		
		public function set position(value:int):void
		{
			_position = value;
			
			if(position >= duration){
				updateTargetPropValues(1);
			}else if(position > 0){
				updateTargetPropValues(ease(position/duration));
			}else{//value <= 0
				updateTargetPropValues(0);
			}
		}
		
		public function get duration():Number
		{
			return _duration;
		}
		
		private function update(timeElapsed:int):void
		{
			position += timeElapsed;
			
			lambda.call(onUpdate);
			
			if(position >= duration)
			{
				this.stop();
				lambda.call(onEnd);
			}
		}
		
		private function updateTargetPropValues(ratio:Number):void
		{
			for(var propName:String in propInfoDict){
				var propRange:Range = propInfoDict[propName];
				_target[propName] = propRange.getValue(ratio);
			}
		}
		
		private function createPropInfoDict():void
		{
			if(propInfoDict){
				return;
			}
			
			propInfoDict = {};
			for(var propName:String in props){
				addProp(propName, props[propName]);
			}
		}
		
		private function addProp(propName:String, propValue:*):void
		{
			var propEndValue:Number;
			
			if(propValue is Array){
				propEndValue = getValue(propName, propValue[1]);
				_target[propName] = getValue(propName, propValue[0]);
			}else{
				propEndValue = getValue(propName, propValue);
			}
			
			propInfoDict[propName] = new Range(_target[propName], propEndValue);
		}
		
		private function delConflictProp(propName:String):void
		{
			deleteKey(propInfoDict, propName);
		}
		
		private function getValue(propName:String, val:*):Number
		{
			if(!(val is String)){
				return val as Number;
			}
			return Number(_target[propName]) + Number(val);
		}
	}
}