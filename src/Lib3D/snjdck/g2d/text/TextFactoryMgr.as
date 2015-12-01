package snjdck.g2d.text
{
	internal class TextFactoryMgr
	{
		static private const FactoryList:Array = [];
		
		static public function Fetch(fontSize:int):TextFactory
		{
			var factory:TextFactory = FactoryList[fontSize];
			if(null == factory){
				factory = new TextFactory(fontSize);
				FactoryList[fontSize] = factory;
			}
			return factory;
		}
	}
}