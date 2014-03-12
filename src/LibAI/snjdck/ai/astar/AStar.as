package snjdck.ai.astar
{
	import array.has;
	
	import flash.ds.BinHeap;
	
	final public class AStar
	{
		static public function FindPath(startNode:IAstarNode, endNode:IAstarNode):Array
		{
			const opened:BinHeap = new BinHeap("f");	//待考察
			const closed:Array = [];				//已考察
			
			startNode.g = 0;
			startNode.f = startNode.heuristic(endNode);
			
			var currentNode:IAstarNode = startNode;
			
			while(currentNode != endNode){
				closed.push(currentNode);
				for each(var testNode:IAstarNode in currentNode.getOutputNodes()){
					if (null == testNode) continue;
					if (!currentNode.canWalkTo(testNode)) continue;
					if (array.has(closed, testNode)) continue;
					
					var isTestNodeInOpen:Boolean = opened.has(testNode);
					var g:Number = currentNode.g + currentNode.heuristic(testNode);
					var f:Number = g + testNode.heuristic(endNode);
					if(isTestNodeInOpen && f >= testNode.f){
						continue;
					}
					testNode.parent = currentNode;
					testNode.g = g;
					if(isTestNodeInOpen){
						opened.update(testNode, f);
					}else{
						testNode.f = f;
						opened.push(testNode);
					}
				}
				if(opened.isEmpty()){
					return null;
				}
				currentNode = opened.shift();
			}
			
			return BuildPath(startNode, endNode);
		}
		
		static private function BuildPath(startNode:IAstarNode, endNode:IAstarNode):Array
		{
			const path:Array = [endNode];
			var node:IAstarNode = endNode;
			
			while(node != startNode){
				node = node.parent;
				path.push(node);
			}
			
			path.reverse();
			
			for(var i:int=0; i<path.length; i++){
				node = path[i];
				if(!node.walkable){
					path.splice(i);
					break;
				}
			}
			
			return path;
		}
	}
}