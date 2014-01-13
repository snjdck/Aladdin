package snjdck.entityengine.systems
{
	import flash.display.DisplayObjectContainer;
	
	import snjdck.entityengine.ISystem;
	import snjdck.entityengine.NodeList;
	import snjdck.entityengine.nodes.RenderNode;
	
	public class RenderSystem implements ISystem
	{
		[Inject]
		public var uiDock:DisplayObjectContainer;
		
		[Inject("org.patterns.entity.nodes.RenderNode")]
		public var nodeList:NodeList;
		
		public function RenderSystem()
		{
		}
		
		public function onInit():void
		{
			for each(var node:RenderNode in nodeList){
				addToStage(node);
			}
			nodeList.onNodeAdd.add(addToStage);
			nodeList.onNodeDel.add(removeFromStage);
		}
		
		private function addToStage(node:RenderNode):void
		{
			uiDock.addChild(node.display.displayObject);
		}
		
		private function removeFromStage(node:RenderNode):void
		{
			uiDock.removeChild(node.display.displayObject);
		}
		
		public function onUpdate(timeElapsed:int):void
		{
			for each(var node:RenderNode in nodeList){
				node.update();
			}
		}
	}
}