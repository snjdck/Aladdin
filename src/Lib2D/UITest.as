package
{
	import flash.display.Sprite;
	
	import htmlui.UIObjectContainer;
	import htmlui.layout.FlowLayout;
	
	public class UITest extends Sprite
	{
		public function UITest()
		{
			var sp1:Sprite = createBox();
			var sp2:Sprite = createBox(100, 0xFF0000);
			
			var c:UIObjectContainer = new UIObjectContainer();
			c.layout = new FlowLayout(c);
			c.addElement(sp1);
			c.addElement(sp2);
			addChild(c);
		}
		
		private function createBox(size:int=100, color:uint=0x000000):Sprite
		{
			var sp:Sprite = new Sprite();
			with(sp.graphics){
				beginFill(color, 1);
				drawRect(0, 0, size, size);
				endFill();
			}
			return sp;
		}
	}
}