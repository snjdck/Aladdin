package snjdck.effect.tween
{
	import dict.deleteKey;
	
	import flash.support.Range;
	
	import lambda.call;

	final public class Tween
	{
		static private const ticker:TweenTicker = new TweenTicker();
		
		static public function KillTweensOf(target:Object):void
		{
			ticker.killTweensOf(target);
		}
		
		private var hasInit:Boolean;
		private var _target:Object;
		private var _position:int;
		private var _duration:int;
		private var ease:Function;
		private var props:Object;
		
		private var onUpdate:Object;
		private var onEnd:Object;
		
		internal var nextSibling:Tween;
		
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
			ticker.addTween(this);
		}
		
		public function stop():void
		{
			ticker.removeTween(this);
		}
		
		public function get running():Boolean
		{
			return ticker.isTweenRunning(this);
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
		
		internal function update(timeElapsed:int):void
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
			for(var propName:String in props){
				var propRange:Range = props[propName];
				_target[propName] = propRange.getValue(ratio);
			}
		}
		
		private function createPropInfoDict():void
		{
			if (hasInit) return;
			hasInit = true;
			
			var propDict:Object = {};
			for(var propName:String in props){
				addProp(propDict, propName, props[propName]);
			}
			props = propDict;
		}
		
		private function addProp(propDict:Object, propName:String, propValue:*):void
		{
			var propEndValue:Number;
			
			if(propValue is Array){
				propEndValue = getValue(propName, propValue[1]);
				_target[propName] = getValue(propName, propValue[0]);
			}else{
				propEndValue = getValue(propName, propValue);
			}
			
			propDict[propName] = new Range(_target[propName], propEndValue);
		}
		
		private function getValue(propName:String, val:*):Number
		{
			if(!(val is String)){
				return val as Number;
			}
			return Number(_target[propName]) + Number(val);
		}
		
		internal function delConflictPropsOnOtherTweens(otherTween:Tween):void
		{
			while(otherTween){
				for(var propName:String in props){
					deleteKey(otherTween.props, propName);
				}
				otherTween = otherTween.nextSibling;
			}
		}
	}
}