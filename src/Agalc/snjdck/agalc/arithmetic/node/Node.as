package snjdck.agalc.arithmetic.node
{
	import snjdck.agalc.arithmetic.TempRegFactory;
	
	import string.repeat;
	import string.replace;

	public class Node
	{
		private var _type:NodeType;
		private var _value:String;
		
		public var realValue:*;
		
		public var firstChild:Node;
		public var nextSibling:Node;
		
		public function Node(type:NodeType, value:String=null)
		{
			this._type = type;
			this._value = value;
			onInit();
		}

		public function get type():NodeType
		{
			return _type;
		}

		public function set type(newType:NodeType):void
		{
			if(type == NodeType.VAR_ID && newType == NodeType.STRING){
				_type = newType;
			}else{
				throw new Error("type can't be set!");
			}
		}
		
		public function get value():String
		{
			return _value;
		}
		
		private function onInit():void
		{
			switch(type)
			{
				case NodeType.NUM:
					realValue = parseFloat(value);
					break;
				case NodeType.STRING:
					realValue = value.slice(1, -1);
					break;
				default:
					realValue = value;
			}
		}
		
		public function get leftChild():Node
		{
			return firstChild;
		}
		
		public function get rightChild():Node
		{
			return firstChild && firstChild.nextSibling;
		}
		
		public function visit(output:Array, regFactory:TempRegFactory):String
		{
			if(rightChild)
			{
				var a:String = leftChild.visit(output, regFactory);
				var b:String = rightChild.visit(output, regFactory);
				var c:String = getC(a, b, regFactory);
				output.push([value, c, a, b]);
				return c;
			}
			return value;
		}
		
		protected function getC(a:String, b:String, regFactory:TempRegFactory):String
		{
			if(regFactory.isTempReg(a)){
				if(regFactory.isTempReg(b)){
					regFactory.restoreTempReg(b);
				}
				return a;
			}
			if(regFactory.isTempReg(b)){
				return b;
			}
			if(regFactory.hasValidTempReg()){
				return regFactory.retrieveTempReg();
			}
			throw "register use out!";
		}

		public function toString(level:int=0):String
		{
			var children:Array = [];
			
			var argNode:Node = firstChild;
			while(argNode){
				children.push(argNode.toString(level+1));
				argNode = argNode.nextSibling;
			}
			
			return string.replace(
				"${0}[${1}:${2}]{\n${3}\n${0}}",
				[
					string.repeat("\t", level),
					type.toString(),
					value,
					children.join(",\n")
				]
			);
		}
	}
}