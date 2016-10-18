package snjdck.quadtree
{
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.cameras.ClassifyResult;
	import snjdck.g3d.cameras.ViewFrustum;

	/**
	 * 00 01
	 * 10 11
	 */
	final public class QuadTree
	{
		private var parent:QuadTree;
		private var centerX:Number;
		private var centerY:Number;
		
		private const bound:AABB = new AABB();
		
		private var hasNode:Boolean;
		private var nodeList:Array;
		
		private var hasItem:Boolean;
		private var itemList:Array;
		
		public function QuadTree(parent:QuadTree, centerX:int, centerY:int, halfSize:int, minSize:int)
		{
			this.parent = parent;
			this.centerX = centerX;
			this.centerY = centerY;
			bound.center.x = centerX;
			bound.center.y = centerY;
			bound.halfSize.x = halfSize;
			bound.halfSize.y = halfSize;
			if(halfSize > minSize){
				createChildren(halfSize >> 1, minSize);
			}
		}
		
		private function createChildren(childHalfSize:int, minSize:int):void
		{
			nodeList = new Array(4);
			nodeList[0] = new QuadTree(this, centerX - childHalfSize, centerY - childHalfSize, childHalfSize, minSize);
			nodeList[1] = new QuadTree(this, centerX + childHalfSize, centerY - childHalfSize, childHalfSize, minSize);
			nodeList[2] = new QuadTree(this, centerX - childHalfSize, centerY + childHalfSize, childHalfSize, minSize);
			nodeList[3] = new QuadTree(this, centerX + childHalfSize, centerY + childHalfSize, childHalfSize, minSize);
			hasNode = true;
		}
		
		private function classifyNode(item:IQuadTreeItem):QuadTree
		{
			var isInTopQuadrant:Boolean = item.y + item.height <= centerY;
			var isInBottomQuadrant:Boolean = item.y >= centerY;
			if(!(isInTopQuadrant || isInBottomQuadrant)){
				return this;
			}
			var isInLeftQuadrant:Boolean = item.x + item.width <= centerX;
			var isInRightQuadrant:Boolean = item.x >= centerX;
			if(!(isInLeftQuadrant || isInRightQuadrant)){
				return this;
			}
			var index:int = (isInTopQuadrant ? 0 : 2) | (isInLeftQuadrant ? 0 : 1);
			return nodeList[index];
		}
		
		private function findTargetTree(item:IQuadTreeItem):QuadTree
		{
			var targetTree:QuadTree = this;
			var testTree:QuadTree = null;
			for(;;){
				if(!targetTree.hasNode)
					break;
				testTree = targetTree.classifyNode(item);
				if(testTree == targetTree)
					break;
				targetTree = testTree;
			}
			return targetTree;
		}
			
		public function insert(item:IQuadTreeItem):void
		{
			var targetTree:QuadTree = findTargetTree(item);
			if(targetTree.hasItem){
				targetTree.itemList.push(item);
			}else{
				targetTree.itemList = [item];
				targetTree.hasItem = true;
			}
			var nodeBound:AABB = item.getBound();
			if(nodeBound.halfSize.z <= 0){
				return;
			}
			do{
				targetTree.bound.mergeZ(nodeBound);
				targetTree = targetTree.parent;
			}while(targetTree != null);
		}
		
		public function getObjectsInFrustum(viewFrustum:ViewFrustum, result:Array):void
		{
			var currentNode:QuadTree = this;
			for(;;){
				switch(viewFrustum.classify(currentNode.bound)){
					case ClassifyResult.INTERECT:
						if(currentNode.hasItem){
							for each(var item:IQuadTreeItem in currentNode.itemList){
								if(viewFrustum.classify(item.getBound()) <= 0){
									result.push(item);
								}
							}
						}
						if(currentNode.hasNode){
							list_1.push.apply(null, currentNode.nodeList);
						}
						break;
					case ClassifyResult.CONTAINS:
						currentNode.collectObjsRecursively(result);
						break;
				}
				if(list_1.length <= 0)
					break;
				currentNode = list_1.pop();
			}
		}
		
		private function collectObjsRecursively(result:Array):void
		{
			var currentNode:QuadTree = this;
			for(;;){
				if(currentNode.hasItem) result.push.apply(null, currentNode.itemList);
				if(currentNode.hasNode) list_2.push.apply(null, currentNode.nodeList);
				if(list_2.length <= 0)
					break;
				currentNode = list_2.pop();
			}
		}
		
		static private const list_1:Array = [];
		static private const list_2:Array = [];
	}
}