package snjdck.quadtree
{
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.ViewFrustum;

	/**
	 * 00 01
	 * 10 11
	 */
	final public class QuadTree
	{
		private var centerX:Number;
		private var centerY:Number;
		
		private var nodeList:Array;
		private var parent:QuadTree;
		private const objectList:Array = [];
		private const bound:AABB = new AABB();
		
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
		}
		
		private function classifyNode(node:IQuadTreeNode):QuadTree
		{
			var isInTopQuadrant:Boolean = node.y + node.height <= centerY;
			var isInBottomQuadrant:Boolean = node.y >= centerY;
			if(!(isInTopQuadrant || isInBottomQuadrant)){
				return this;
			}
			var isInLeftQuadrant:Boolean = node.x + node.width <= centerX;
			var isInRightQuadrant:Boolean = node.x >= centerX;
			if(!(isInLeftQuadrant || isInRightQuadrant)){
				return this;
			}
			var index:int = (isInTopQuadrant ? 0 : 2) | (isInLeftQuadrant ? 0 : 1);
			return nodeList[index];
		}
		
		private function findTargetTree(node:IQuadTreeNode):QuadTree
		{
			var targetTree:QuadTree = this;
			var testTree:QuadTree = null;
			for(;;){
				if(null == targetTree.nodeList)
					break;
				testTree = targetTree.classifyNode(node);
				if(testTree == targetTree)
					break;
				targetTree = testTree;
			}
			return targetTree;
		}
			
		public function insert(node:IQuadTreeNode):void
		{
			var targetTree:QuadTree = findTargetTree(node);
			/*
			if(targetTree.objectList.length > 1){
				enterDebugger();
			}
			*/
			targetTree.objectList.push(node);
			var nodeBound:AABB = node.getBound();
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
					case ViewFrustum.INTERECT:
						for each(var item:IQuadTreeNode in currentNode.objectList){
							if(viewFrustum.classify(item.getBound()) <= 0){
								result.push(item);
							}
						}
						if(currentNode.nodeList != null){
							nodeList1.push.apply(null, currentNode.nodeList);
						}
						break;
					case ViewFrustum.CONTAINS:
						currentNode.collectObjsRecursively(result);
						break;
				}
				if(nodeList1.length <= 0)
					break;
				currentNode = nodeList1.pop();
			}
		}
		
		private function collectObjsRecursively(result:Array):void
		{
			var currentNode:QuadTree = this;
			for(;;){
				result.push.apply(null, currentNode.objectList);
				if(currentNode.nodeList != null)
					nodeList2.push.apply(null, currentNode.nodeList);
				if(nodeList2.length <= 0)
					break;
				currentNode = nodeList2.pop();
			}
		}
		
		static private const nodeList1:Array = [];
		static private const nodeList2:Array = [];
	}
}