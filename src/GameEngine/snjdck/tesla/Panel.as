package snjdck.tesla
{
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import snjdck.tesla.core.IPanel;
	import snjdck.tesla.core.PanelShowPolicy;
	
	import flash.signals.ISignal;
	import flash.signals.Signal;

	public class Panel implements IPanel
	{
		private var _showPolicy:String;
		private var target:Sprite;
		
		private const _showSignal:Signal = new Signal();
		private const _hideSignal:Signal = new Signal();
		
		public function Panel(color:uint)
		{
			var sp:Sprite = new Sprite();
			sp.visible = false;
			var g:Graphics = sp.graphics;
			g.beginFill(color);
			g.drawRect(0, 0, 200, 200);
			g.endFill();
			
			
			this._showPolicy = PanelShowPolicy.ALWAYS;
			this.target = sp;
		}
		
		public function isShowing():Boolean
		{
			return target.visible;
		}
		
		public function show():void
		{
			if(isShowing()){
				return;
			}
			target.visible = true;
			_showSignal.notify();
		}
		
		public function hide():void
		{
			if(isShowing() == false){
				return;
			}
			target.visible = false;
			_hideSignal.notify();
		}
		
		public function get showPolicy():String
		{
			return _showPolicy;
		}
		
		public function set showPolicy(value:String):void
		{
			_showPolicy = value;
		}
		
		public function get showSignal():ISignal
		{
			return _showSignal;
		}
		
		public function get hideSignal():ISignal
		{
			return _hideSignal;
		}
		
		public function toggleShowHide():void
		{
			if(isShowing()){
				hide();
			}else{
				show();
			}
		}
		
		public function get autoArrange():Boolean
		{
			return true;
		}
		
		public function getDisplayObject():DisplayObject
		{
			return target;
		}
		
		public function get isModal():Boolean
		{
			return false;
		}
		
	}
}