package snjdck.entityengine.helper
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import dict.deleteKey;
	import dict.hasKey;
	
	import snjdck.entityengine.Entity;
	import snjdck.entityengine.EntityEngine;
	import snjdck.entityengine.NodeList;
	import snjdck.entityengine.nodes.DisplayNode;
	import flash.mvc.Module;
	
	public class EntityEngineFacade extends Module
	{
		protected var entityEngine:EntityEngine;
		private var allEntityNodes:NodeList;
		
		private var uiDict:Object;
		
		public function EntityEngineFacade(context:Object)
		{
			super();
			injector.mapValue(EntityEngineFacade, this);
			entityEngine = new EntityEngine(injector);
			allEntityNodes = entityEngine.getNodeList(DisplayNode);
			uiDict = new Dictionary();
			allEntityNodes.onNodeAdd.add(__onNodeAdd);
			allEntityNodes.onNodeDel.add(__onNodeDel);
		}
		
		private function __onNodeAdd(node:DisplayNode):void
		{
			var ui:DisplayObject = node.display.displayObject;
			if(hasKey(uiDict, ui)){
				throw new Error("ui can't be sharded in different entities!");
			}else{
				uiDict[ui] = node.entity;
			}
		}
		
		private function __onNodeDel(node:DisplayNode):void
		{
			deleteKey(uiDict, node.display.displayObject);
		}
		
		public function getEntityByUI(ui:DisplayObject):Entity
		{
			return uiDict[ui];
		}
	}
}