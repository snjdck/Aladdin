package snjdck.quadtree
{
	import flash.debugger.enterDebugger;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.bound.Rect45;
	import snjdck.gpu.geom.AABB2;

	/**
	 * 00 01
	 * 10 11
	 */
	final public class QuadTree extends AABB2
	{
		static public function Create(halfSize:int, minSize:int):QuadTree
		{
			return new QuadTree(0, 0, 0x4000, 64);
		}
		
		private var nodeList:Array;
		private const objectList:Array = [];
		
		public function QuadTree(centerX:int, centerY:int, halfSize:int, minSize:int)
		{
			this.center = new Vector3D(centerX, centerY);
			this.halfWidth = halfSize;
			this.halfHeight = halfSize;
			onInit(minSize);
		}
		
		private function onInit(minSize:int):void
		{
			if(halfWidth <= minSize || halfHeight <= minSize){
				return;
			}
			var childHalfSize:int = halfWidth >> 1;
			nodeList = new Array(4);
			nodeList[0] = new QuadTree(center.x - childHalfSize, center.y - childHalfSize, childHalfSize, minSize);
			nodeList[1] = new QuadTree(center.x + childHalfSize, center.y - childHalfSize, childHalfSize, minSize);
			nodeList[2] = new QuadTree(center.x - childHalfSize, center.y + childHalfSize, childHalfSize, minSize);
			nodeList[3] = new QuadTree(center.x + childHalfSize, center.y + childHalfSize, childHalfSize, minSize);
		}
		
		private function classifyNode(node:IQuadTreeNode):QuadTree
		{
			var isInTopQuadrant:Boolean = node.y + node.height <= center.y;
			var isInBottomQuadrant:Boolean = node.y >= center.y;
			if(!(isInTopQuadrant || isInBottomQuadrant)){
				return this;
			}
			var isInLeftQuadrant:Boolean = node.x + node.width <= center.x;
			var isInRightQuadrant:Boolean = node.x >= center.x;
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
				if(null == targetTree.nodeList){
					break;
				}
				testTree = targetTree.classifyNode(node);
				if(testTree == targetTree){
					break;
				}
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
		}
		
		public function getObjectsByFrustum(center:Vector3D, halfWidth:Number, result:Array):void
		{
			var stack:Array = [this];
			var halfSize:Number = halfWidth * Math.SQRT2;
			while(stack.length > 0){
				var currentNode:QuadTree = stack.pop();
				var offset:Vector3D = center.subtract(currentNode.center);
				var distance:Number = Math.abs(offset.x - offset.y) - halfSize;
				var nodeHalfSize:Number = currentNode.halfWidth + currentNode.halfHeight;
				if( distance >= nodeHalfSize){
					continue;
				}
				if(-distance >= nodeHalfSize){
					currentNode.collectObjsRecursively(result);
					continue;
				}
				result.push.apply(null, currentNode.objectList);
				if(currentNode.nodeList != null){
					stack.push.apply(null, currentNode.nodeList);
				}
			}
		}
		
		public function getObjectsInArea(rect:Rect45, result:Array):void
		{
			var stack:Array = [this];
			while(stack.length > 0){
				var currentNode:QuadTree = stack.pop();
				switch(rect.classify(currentNode.center, currentNode.halfWidth, currentNode.halfHeight)){
				case Rect45.INTERECT:
					result.push.apply(null, currentNode.objectList);
					if(currentNode.nodeList != null){
						stack.push.apply(null, currentNode.nodeList);
					}
					break;
				case Rect45.CONTAINS:
					currentNode.collectObjsRecursively(result);
					break;
				}
			}
		}
		
		private function collectObjsRecursively(result:Array):void
		{
			var stack:Array = [this];
			while(stack.length > 0){
				var currentNode:QuadTree = stack.pop();
				result.push.apply(null, currentNode.objectList);
				if(currentNode.nodeList != null){
					stack.push.apply(null, currentNode.nodeList);
				}
			}
		}
	}
}