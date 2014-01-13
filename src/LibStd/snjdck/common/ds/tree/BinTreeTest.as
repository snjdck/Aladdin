package snjdck.common.ds.tree
{
	import flash.utils.getTimer;

	public class BinTreeTest
	{
		/**
		 *           1
		 *      2          3
		 *   4    5      6   7
		 *  8 9 10 11 12 13 14 15
		 */		
		static public function Test():void
		{
			var n1:TestNode = new TestNode(1);
			
			var n2:TestNode = n1.createLeftChild(2);
			var n3:TestNode = n1.createRightChild(3);
			
			var n4:TestNode = n2.createLeftChild(4);
			var n5:TestNode = n2.createRightChild(5);
			
			var n6:TestNode = n3.createLeftChild(6);
			var n7:TestNode = n3.createRightChild(7);
			
			var n8:TestNode = n4.createLeftChild(8);
			var n9:TestNode = n4.createRightChild(9);
			
			var n10:TestNode = n5.createLeftChild(10);
			var n11:TestNode = n5.createRightChild(11);
			
			var n12:TestNode = n6.createLeftChild(12);
			var n13:TestNode = n6.createRightChild(13);
			
			var n14:TestNode = n7.createLeftChild(14);
			var n15:TestNode = n7.createRightChild(15);
			
			var str:String;
			function testFunc(node:TestNode):void{
				str += node.data + ",";
			}
			function assert(func:Function, result:String):void{
				str = "";
				func(n1, testFunc);
				trace(str === result);
			}
			
			assert(BinTreeVisitor.VisitByDepth, 	"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,");
			assert(BinTreeVisitor.VisitPreOrder, 	"1,2,4,8,9,5,10,11,3,6,12,13,7,14,15,");
			assert(BinTreeVisitor.VisitInOrder, 	"8,4,9,2,10,5,11,1,12,6,13,3,14,7,15,");
			assert(BinTreeVisitor.VisitPostOrder, 	"8,9,4,10,11,5,2,12,13,6,14,15,7,3,1,");
			return;
			
			var t1:int, t2:int, i:int;
			const n:int = 10000;
			
			t1 = getTimer();
			for(i=0; i<n; i++){
				BinTreeVisitor.VisitByDepth(n1, printNode);
			}
			t2 = getTimer();
			trace(t2-t1);
			
			
			t1 = getTimer();
			for(i=0; i<n; i++){
				BinTreeVisitor.VisitPreOrder(n1, printNode);
			}
			t2 = getTimer();
			trace(t2-t1);
			
			t1 = getTimer();
			for(i=0; i<n; i++){
				BinTreeVisitor.VisitInOrder(n1, printNode);
			}
			t2 = getTimer();
			trace(t2-t1);
			
			t1 = getTimer();
			for(i=0; i<n; i++){
				BinTreeVisitor.VisitPostOrder(n1, printNode);
			}
			t2 = getTimer();
			trace(t2-t1);
		}
	}
}
import snjdck.common.ds.tree.IBinTreeNode;


function printNode(node:TestNode):void
{
	trace(node.data);
}

class TestNode implements IBinTreeNode
{
	public var _left:IBinTreeNode;
	public var _right:IBinTreeNode;
	
	public var data:*;
	
	public function TestNode(data:Object)
	{
		this.data = data;
	}
	
	public function createLeftChild(data:Object):TestNode
	{
		var node:TestNode = new TestNode(data);
		
		this._left = node;
		
		return node;
	}
	
	public function createRightChild(data:Object):TestNode
	{
		var node:TestNode = new TestNode(data);
		
		this._right = node;
		
		return node;
	}
	
	public function get leftChild():IBinTreeNode
	{
		return _left;
	}
	
	public function get rightChild():IBinTreeNode
	{
		return _right;
	}
}