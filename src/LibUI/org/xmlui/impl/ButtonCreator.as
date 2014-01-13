package org.xmlui.impl
{
	import org.xmlui.IUICreator;
	import org.xmlui.UICreator;
	import org.xmlui.button.Button;
	import org.xmlui.support.Image;
	
	public class ButtonCreator extends UICreator implements IUICreator
	{
		public function ButtonCreator()
		{
		}
		
		public function createUI(elementConfig:XML):*
		{
			var button:Button = new Button();
			initProp(button, elementConfig);
			if(elementConfig.hasOwnProperty("@upSkin")){
				var upSkinPath:String = elementConfig.attribute("upSkin");
				button.upSkin = new Image(upSkinPath, function():void{
					var isWidthSet:Boolean = elementConfig.hasOwnProperty("@width");
					var isHeightSet:Boolean = elementConfig.hasOwnProperty("@height");
					if(isWidthSet && isHeightSet){
						return;
					}
					if(!isWidthSet){
						button.width = button.upSkin.width;
					}
					if(!isHeightSet){
						button.height = button.upSkin.height;
					}
					button.onResize();
				});
			}
			if(elementConfig.hasOwnProperty("@overSkin")){
				var overSkinPath:String = elementConfig.attribute("overSkin");
				button.overSkin = new Image(overSkinPath);
			}
			if(elementConfig.hasOwnProperty("@downSkin")){
				var downSkinPath:String = elementConfig.attribute("downSkin");
				button.downSkin = new Image(downSkinPath);
			}
			return button;
		}
	}
}