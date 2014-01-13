package snjdck.quadtree
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;

	/**
	 * 00 01
	 * 10 11
	 */
	final public class QuadTree
	{
		static public function Create(bounds:Rectangle, maxLevel:int):QuadTree
		{
			return new QuadTree(null, bounds, 0, maxLevel);
		}
		
		private var parent:QuadTree;
		private const nodeList:Vector.<QuadTree> = new Vector.<QuadTree>(4, true);
		private const objectList:Array = [];
		
		private var bounds:Rectangle;
		private var hasChildren:Boolean;
		private var centerX:int;
		private var centerY:int;
		
		public function QuadTree(parent:QuadTree, bounds:Rectangle, level:int, maxLevel:int)
		{
			this.parent = parent;
			this.bounds = bounds;
			onInit(level, maxLevel);
		}
		
		private function onInit(level:int, maxLevel:int):void
		{
			var x:int = bounds.x;
			var y:int = bounds.y;
			var subWidth:int = bounds.width >> 1;
			var subHeight:int = bounds.height >> 1;
			
			hasChildren = level < maxLevel;
			centerX = x + subWidth;
			centerY = y + subHeight;
			
			if(hasChildren == false){
				return;
			}
			
			var nextLevel:int = level + 1;
			nodeList[0] = new QuadTree(this, new Rectangle(x, 		y, 		 subWidth, subHeight), nextLevel, maxLevel);
			nodeList[1] = new QuadTree(this, new Rectangle(centerX,	y, 		 subWidth, subHeight), nextLevel, maxLevel);
			nodeList[2] = new QuadTree(this, new Rectangle(x, 		centerY, subWidth, subHeight), nextLevel, maxLevel);
			nodeList[3] = new QuadTree(this, new Rectangle(centerX,	centerY, subWidth, subHeight), nextLevel, maxLevel);
		}
		
		public function clear():void
		{
			objectList.length = 0;
			if(hasChildren == false){
				return;
			}
			for each(var node:QuadTree in nodeList){
				node.clear();
			}
		}
		
		private function classifyNode(node:Object):QuadTree
		{
			var x:Number = node.x;
			var y:Number = node.y;
			var width:Number = node.width;
			var height:Number = node.height;
			
			var isInTopQuadrant:Boolean = y + height < centerY;
			var isInBottomQuadrant:Boolean = y > centerY;
			
			if(!(isInTopQuadrant || isInBottomQuadrant)){
				return this;
			}
			
			var isInLeftQuadrant:Boolean = x + width < centerX;
			var isInRightQuadrant:Boolean = x > centerX;
			
			if(!(isInLeftQuadrant || isInRightQuadrant)){
				return this;
			}
			
			var index:int = (isInTopQuadrant  ? 0 : 2) | (isInLeftQuadrant ? 0 : 1);
			return nodeList[index];
		}
		
		private function findTargetTree(node:Object):QuadTree
		{
			var targetTree:QuadTree = this;
			var testTree:QuadTree = null;
			
			while(true){
				if(false == targetTree.hasChildren){
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
			targetTree.addNode(node);
		}
		
		private function addNode(node:IQuadTreeNode):void
		{
			objectList.push(node);
			node.parent = this;
		}
		
		private function removeNode(node:IQuadTreeNode):void
		{
			var index:int = objectList.indexOf(node);
			if(index < 0){
				return;
			}
			objectList.splice(index, 1);
			node.parent = null;
		}
		
		public function retrive(node:IQuadTreeNode, result:Array):void
		{
			var tree:QuadTree = node.parent;
			while(tree != null){
				result.push.apply(null, tree.objectList);
				tree = tree.parent;
			}
		}
		
		public function update(node:IQuadTreeNode):void
		{
			var targetTree:QuadTree = findTargetTree(node);
			
			if(targetTree == node.parent){
				return;
			}
			
			node.parent.removeNode(node);
			targetTree.addNode(node);
		}
		
		public function getObjectsInArea(rect:Rectangle):Array
		{
			var result:Array = [];
			getObjectsInAreaImpl(rect, result);
			return result;
		}
		
		private function getObjectsInAreaImpl(rect:Rectangle, result:Array):void
		{
			var tree:QuadTree = findTargetTree(rect);
			while(tree != null){
				for each(var node:IQuadTreeNode in tree.objectList){
					if(intersects(node, rect)){
						result[result.length] = node;
					}
				}
				tree = tree.parent;
			}
		}
		
		private function intersects(node:IQuadTreeNode, rect:Rectangle):Boolean
		{
			if(node.x >= rect.right){
				return false;
			}
			if(node.y >= rect.bottom){
				return false;
			}
			if(node.x + node.width <= rect.x){
				return false;
			}
			if(node.y + node.height <= rect.y){
				return false;
			}
			return true;
		}
		
		public function drawGrid(g:Graphics):void
		{
			g.lineStyle(0x000000);
			
			g.moveTo(centerX, bounds.y);
			g.lineTo(centerX, bounds.bottom);
			g.moveTo(bounds.x, centerY);
			g.lineTo(bounds.right, centerY);
			
			if(hasChildren == false){
				return;
			}
			for each(var node:QuadTree in nodeList){
				node.drawGrid(g);
			}
		}
		
		public function drawCell(g:Graphics):void
		{
			g.lineStyle(0x00FF00);
			g.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			g.endFill();
		}
	}
}