package org.xmlui.button
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="change", type="flash.events.Event")]
	
	public class ButtonModel extends EventDispatcher
	{
		private var _isRollOver:Boolean;
		private var _isPressed:Boolean;
		private var _isSelected:Boolean;
		private var _isEnabled:Boolean;
		private var _isToggled:Boolean;
		
		public function ButtonModel()
		{
			_isRollOver = false;
			_isPressed = false;
			_isSelected = false;
			_isEnabled = true;
			_isToggled = false;
		}
		
		private function notifyEvent():void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get isRollOver():Boolean
		{
			return _isRollOver;
		}

		public function get isPressed():Boolean
		{
			return _isPressed;
		}

		public function get isSelected():Boolean
		{
			return _isSelected;
		}

		public function get isEnabled():Boolean
		{
			return _isEnabled;
		}

		public function get isToggled():Boolean
		{
			return _isToggled;
		}

		public function set isRollOver(value:Boolean):void
		{
			if(false == _isEnabled || _isRollOver == value){
				return;
			}
			_isRollOver = value;
			notifyEvent();
		}

		public function set isPressed(value:Boolean):void
		{
			if(false == _isEnabled || _isPressed == value){
				return;
			}
			if(_isToggled && value){
				_isSelected = !_isSelected;
			}
			_isPressed = value;
			notifyEvent();
		}

		public function set isEnabled(value:Boolean):void
		{
			if(_isEnabled == value){
				return;
			}
			if(_isEnabled){
				_isRollOver = false;
				_isPressed = false;
			}
			_isEnabled = value;
			notifyEvent();
		}

		public function set isToggled(value:Boolean):void
		{
			_isToggled = value;
		}
		
		public function set isSelected(value:Boolean):void
		{
			if(false == _isEnabled || _isSelected == value){
				return;
			}
			_isSelected = value;
			notifyEvent();
		}
	}
}