package snjdck.entityengine
{
	import array.delWhen;
	
	import avmplus.getTypeInfo;
	
	import stdlib.components.ObjectPool;
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import stdlib.reflection.getType;
	import stdlib.reflection.typeinfo.VariableInfo;
	
	import snjdck.signal.Signal;

	final public class NodeList extends Proxy
	{
		public const onNodeAdd:Signal = new Signal(Node);
		public const onNodeDel:Signal = new Signal(Node);
		
		private var componentDict:Object;
		
		private var pool:ObjectPool;
		
		private var nodeList:Array;
		private var nodeType:Class;
		
		public function NodeList(nodeType:Class)
		{
			componentDict = {};
			this.nodeType = nodeType;
			nodeList = [];
			pool = new ObjectPool(nodeType);
			init();
		}
		
		private function init():void
		{
			for each(var varInfo:VariableInfo in getTypeInfo(nodeType).variables){
				if(varInfo.canWrite()){
					componentDict[varInfo.name] = getType(varInfo.type);
				}
			}
		}
		
		public function addNodeByEntityIfMatch(entity:Entity):void
		{
			if(!hasEntity(entity) && testEntity(entity)){
				var node:Node = createNode(entity);
				nodeList.push(node);
				entity.onComponentDel.add(__onEntityComponentDel);
				onNodeAdd.notify(node);
			}
		}
		
		private function createNode(entity:Entity):Node
		{
			var node:Node = pool.getObjectOut();
			for(var prop:String in componentDict){
				node[prop] = entity.getComponent(componentDict[prop]);
			}
			return node;
		}
		
		public function delNodeByEntity(entity:Entity):void
		{
			var node:Node = array.delWhen(nodeList, "entity", entity);
			if(node != null){
				pool.setObjectIn(node);
				entity.onComponentDel.del(__onEntityComponentDel);
				onNodeDel.notify(node);
			}
		}
		
		private function __onEntityComponentDel(entity:Entity):void
		{
			if(!testEntity(entity)){
				delNodeByEntity(entity);
			}
		}
		
		private function hasEntity(entity:Entity):Boolean
		{
			return array.getItem(nodeList, "entity", entity) != null;
		}
		
		private function testEntity(entity:Entity):Boolean
		{
			for each(var componentType:Class in componentDict){
				if(!entity.hasComponent(componentType)){
					return false;
				}
			}
			return true;
		}
		
		public function isEmpty():Boolean
		{
			return nodeList.length == 0;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return nodeList[name];
		}
		
		override flash_proxy function nextNameIndex(index:int):int
		{
			return index < nodeList.length ? index + 1 : 0;
		}
		
		override flash_proxy function nextValue(index:int):*
		{
			return nodeList[index-1];
		}
		
		override flash_proxy function nextName(index:int):String
		{
			throw new Error("please use 'for each' statement!");
		}
	}
}