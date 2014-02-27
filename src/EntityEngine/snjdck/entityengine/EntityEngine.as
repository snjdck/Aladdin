package snjdck.entityengine
{
	import flash.utils.Dictionary;
	
	import array.del;
	
	import dict.hasKey;
	
	import snjdck.entityengine.helper.InjectionTypeNodeGroup;
	import snjdck.injector.IInjector;
	
	import flash.reflection.getType;

	public class EntityEngine
	{
		private const systemList:Vector.<ISystem> = new Vector.<ISystem>();
		private const entityList:Vector.<Entity> = new Vector.<Entity>();
		private const nodeGroupDict:Object = new Dictionary();
		
		private var injector:IInjector;
		
		public function EntityEngine(injector:IInjector)
		{
			this.injector = injector;
			injector.mapValue(EntityEngine, this);
			injector.mapRule(NodeList, new InjectionTypeNodeGroup());
		}
		
		public function addEntity(entity:Entity):void
		{
			if(false == hasEntity(entity)){
				entityList.push(entity);
				entity.onComponentAdd.add(__onEntityAdd);
				__onEntityAdd(entity);
			}
		}
		
		public function delEntity(entity:Entity):void
		{
			if(hasEntity(entity)){
				array.del(entityList, entity);
				entity.onComponentAdd.del(__onEntityAdd);
				__onEntityDel(entity);
			}
		}
		
		private function hasEntity(entity:Entity):Boolean
		{
			return array.has(entityList, entity);
		}
		
		private function __onEntityAdd(entity:Entity):void
		{
			for each(var nodeGroup:NodeList in nodeGroupDict){
				nodeGroup.addNodeByEntityIfMatch(entity);
			}
		}
		
		private function __onEntityDel(entity:Entity):void
		{
			for each(var nodeGroup:NodeList in nodeGroupDict){
				nodeGroup.delNodeByEntity(entity);
			}
		}
		
		public function delAllEntities():void
		{
			for each(var entity:Entity in entityList){
				delEntity(entity);
			}
		}
		
		public function addSystem(system:ISystem):void
		{
			if(!hasSystem(system)){
				systemList.push(system);
				injector.injectInto(system);
				system.onInit();
			}
		}
		
		private function hasSystem(val:ISystem):Boolean
		{
			var systemType:Class = getType(val);
			for each(var system:ISystem in systemList){
				if(getType(system) == systemType){
					return true;
				}
			}
			return false;
		}
		
		public function update(timeElapsed:int):void
		{
			for each(var system:ISystem in systemList){
				system.onUpdate(timeElapsed);
			}
		}
		
		public function getNodeList(nodeType:Class):NodeList
		{
			if(!dict.hasKey(nodeGroupDict, nodeType)){
				var nodeGroup:NodeList = new NodeList(nodeType);
				for each(var entity:Entity in entityList){
					nodeGroup.addNodeByEntityIfMatch(entity);
				}
				nodeGroupDict[nodeType] = nodeGroup;
			}
			return nodeGroupDict[nodeType];
		}
	}
}