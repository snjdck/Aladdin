package flash.ds.tree
{
	final public class BinTreeVisitor
	{
		static public function VisitByDepth(rootNode:IBinTreeNode, handler:Function):void
		{
			const queue:Array = [rootNode];
			while(queue.length > 0){
				var currentNode:IBinTreeNode = queue.shift();
				handler(currentNode);
				if(currentNode.leftChild){
					queue.push(currentNode.leftChild);
				}
				if(currentNode.rightChild){
					queue.push(currentNode.rightChild);
				}
			}
		}
		
		static public function VisitPreOrder(rootNode:IBinTreeNode, handler:Function):void
		{
			const stack:Array = [rootNode];
			while(stack.length > 0){
				var currentNode:IBinTreeNode = stack.pop();
				handler(currentNode);
				if(currentNode.rightChild){
					stack.push(currentNode.rightChild);
				}
				if(currentNode.leftChild){
					stack.push(currentNode.leftChild);
				}
			}
		}
		
		static public function VisitInOrder(rootNode:IBinTreeNode, handler:Function):void
		{
			const stack:Array = [];
			var currentNode:IBinTreeNode = rootNode;
			while(null != currentNode){
				stack.push(currentNode);
				currentNode = currentNode.leftChild;
				while(null == currentNode && stack.length > 0){
					currentNode = stack.pop();
					handler(currentNode);
					currentNode = currentNode.rightChild;
				}
			}
		}
		
		static public function VisitPostOrder(rootNode:IBinTreeNode, handler:Function):void
		{
			const stack:Array = [rootNode];
			var currentNode:IBinTreeNode, prevNode:IBinTreeNode;
			while(stack.length > 0){
				currentNode = stack[stack.length-1];
				if(
					(null == currentNode.leftChild && null == currentNode.rightChild) ||
					(prevNode && (prevNode == currentNode.leftChild || prevNode == currentNode.rightChild))
				){
					handler(stack.pop());
					prevNode = currentNode;
				}else{
					if(currentNode.rightChild){
						stack.push(currentNode.rightChild);
					}
					if(currentNode.leftChild){
						stack.push(currentNode.leftChild);
					}
				}
			}
		}
	}
}