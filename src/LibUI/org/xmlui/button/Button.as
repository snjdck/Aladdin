package org.xmlui.button
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.xmlui.UIPanel;
	
	import ui.support.DefaultConfig;
	import ui.support.createBox;
	
	public class Button extends UIPanel
	{
		protected var _upSkin:DisplayObject;
		protected var _overSkin:DisplayObject;
		protected var _downSkin:DisplayObject;
		protected var _disableSkin:DisplayObject;
		
		protected var _selectedUpSkin:DisplayObject;
		protected var _selectedOverSkin:DisplayObject;
		protected var _selectedDownSkin:DisplayObject;
		protected var _selectedDisableSkin:DisplayObject;
		
		private var currentSkin:DisplayObject;
		
		private const model:ButtonModel = new ButtonModel();
		
		public function Button()
		{
			initDefaultUI();
			mouseChildren = false;
			
			hookEvents([MouseEvent.ROLL_OVER, MouseEvent.ROLL_OUT, MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_UP, MouseEvent.CLICK]);
			model.addEventListener(Event.CHANGE, __onChange);
			
			updateUI();
		}
		
		protected function initDefaultUI():void
		{
			_upSkin = createBox(80, 30, 0xFF0000, 0.8);
		}
		
		private function hookEvents(eventTypes:Array):void
		{
			for each(var eventType:String in eventTypes){
				addEventListener(eventType, __onForwardEvent);
			}
		}
		
		private function __onForwardEvent(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.ROLL_OVER:
					model.isRollOver = true;
					model.isPressed = event.buttonDown;
					break;
				case MouseEvent.ROLL_OUT:
					model.isRollOver = false;
					break;
				case MouseEvent.MOUSE_DOWN:
					model.isPressed = true;
					break;
				case MouseEvent.MOUSE_UP:
					model.isPressed = false;
					break;
			}
		}
		
		private function __onChange(event:Event):void
		{
			updateUI();
		}
		
		public function get enabled():Boolean
		{
			return model.isEnabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			model.isEnabled = value;
			mouseEnabled = value;
			filters = value ? null : [DefaultConfig.FILTER_GRAY];
		}
		
		public function get toggled():Boolean
		{
			return model.isToggled;
		}
		
		public function set toggled(value:Boolean):void
		{
			model.isToggled = value;
		}

		public function get selected():Boolean
		{
			return model.isSelected;
		}
		
		public function set selected(value:Boolean):void
		{
			model.isSelected = value;
		}
		
		private function updateUI():void
		{
			var bmd:DisplayObject;
			
			if(model.isEnabled){
				if(model.isRollOver){
					if(model.isPressed){
						bmd = model.isSelected ? selectedDownSkin : downSkin;
					}else{
						bmd = model.isSelected ? selectedOverSkin : overSkin;
					}
				}else{
					bmd = model.isSelected ? selectedUpSkin : upSkin;
				}
			}else{
				bmd = model.isSelected ? selectedDisableSkin : disableSkin;
			}
			
			setUI(bmd);
		}
		
		private function setUI(value:DisplayObject):void
		{
			if(currentSkin == value){
				return;
			}
			if(currentSkin){
				removeChild(currentSkin);
			}
			currentSkin = value;
			if(currentSkin){
				addChildAt(currentSkin, 0);
			}
		}

		public function get upSkin():DisplayObject
		{
			return _upSkin;
		}

		public function set upSkin(value:DisplayObject):void
		{
			_upSkin = value;
			updateUI();
		}

		public function get overSkin():DisplayObject
		{
			return _overSkin || upSkin;
		}

		public function set overSkin(value:DisplayObject):void
		{
			_overSkin = value;
			updateUI();
		}

		public function get downSkin():DisplayObject
		{
			return _downSkin || upSkin;
		}

		public function set downSkin(value:DisplayObject):void
		{
			_downSkin = value;
			updateUI();
		}

		public function get disableSkin():DisplayObject
		{
			return _disableSkin || upSkin;
		}

		public function set disableSkin(value:DisplayObject):void
		{
			_disableSkin = value;
			updateUI();
		}

		public function get selectedUpSkin():DisplayObject
		{
			return _selectedUpSkin || upSkin;
		}

		public function set selectedUpSkin(value:DisplayObject):void
		{
			_selectedUpSkin = value;
			updateUI();
		}

		public function get selectedOverSkin():DisplayObject
		{
			return _selectedOverSkin || selectedUpSkin;
		}

		public function set selectedOverSkin(value:DisplayObject):void
		{
			_selectedOverSkin = value;
			updateUI();
		}

		public function get selectedDownSkin():DisplayObject
		{
			return _selectedDownSkin || selectedUpSkin;
		}

		public function set selectedDownSkin(value:DisplayObject):void
		{
			_selectedDownSkin = value;
			updateUI();
		}

		public function get selectedDisableSkin():DisplayObject
		{
			return _selectedDisableSkin || selectedUpSkin;
		}

		public function set selectedDisableSkin(value:DisplayObject):void
		{
			_selectedDisableSkin = value;
			updateUI();
		}
	}
}