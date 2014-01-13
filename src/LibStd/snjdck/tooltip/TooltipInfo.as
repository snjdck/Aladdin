package snjdck.tooltip
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import snjdck.effect.tween.impl.Tween;
	import snjdck.effect.tween.TweenEase;

	public class TooltipInfo
	{
		static private const OffsetX:int = 10;
		static private const OffsetY:int = 4;
		
		private var data:Object;
		private var type:Class;
		
		public function TooltipInfo(data:Object, type:Class)
		{
			this.data = data;
			this.type = type;
		}
		
		public function show(dock:DisplayObjectContainer, dict:Object):void
		{
			var tooltip:ITooltip = dict[type];
			
			if(tooltip){
				tooltip.getDisplayObject().visible = true;
			}else{
				tooltip = new type();
				tooltip.onInit();
				dock.addChild(tooltip.getDisplayObject());
				dict[type] = tooltip;
			}
			
			tooltip.setData(getData());
			new Tween(tooltip.getDisplayObject(), 500, {"alpha":[0, 1]}, TweenEase.QuadOut).start();
		}
		
		public function hide(dict:Object):void
		{
			var tooltip:ITooltip = dict[type];
			tooltip.getDisplayObject().visible = false;
		}
		
		public function move(dict:Object, stageX:Number, stageY:Number):void
		{
			var tooltip:ITooltip = dict[type];
			var obj:DisplayObject = tooltip.getDisplayObject();
			
			obj.x = stageX + OffsetX;
			obj.y = stageY + OffsetY;
			
			var stage:Stage = obj.stage;
			var rect:Rectangle = obj.getRect(stage);
			
			if(rect.right > stage.stageWidth){
				obj.x = stageX - obj.width;
			}
			
			if(rect.bottom > stage.stageHeight){
				obj.y = stageY - obj.height;
			}
		}
		
		private function getData():Object
		{
			if(data is String){
				return data;
			}else if(data is Function){
				return data();
			}
			return data;
		}
	}
}