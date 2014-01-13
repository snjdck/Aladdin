package snjdck.agalc.arithmetic.node
{
	final public class NodeType
	{
		static public const UNKNOW				:NodeType = new NodeType("UNKNOW");
		static public const EOF					:NodeType = new NodeType("EOF");
		
		static public const OP_DECLARE			:NodeType = new NodeType("OP_DECLARE");
		static public const OP_ASSIGN			:NodeType = new NodeType("OP_ASSIGN");
		
		static public const KEYWORD_IF			:NodeType = new NodeType("KEYWORD_IF");
		static public const KEYWORD_WHILE		:NodeType = new NodeType("KEYWORD_WHILE");
		static public const KEYWORD_ELSE		:NodeType = new NodeType("KEYWORD_ELSE");
		static public const KEYWORD_VAR			:NodeType = new NodeType("KEYWORD_VAR");
		static public const KEYWORD_FUNC		:NodeType = new NodeType("KEYWORD_FUNC");
		static public const KEYWORD_RETURN		:NodeType = new NodeType("KEYWORD_RETURN");
		
		static public const OP_ADD				:NodeType = new NodeType("OP_ADD");
		static public const OP_SUB				:NodeType = new NodeType("OP_SUB");
		static public const OP_MUL				:NodeType = new NodeType("OP_MUL");
		static public const OP_DIV				:NodeType = new NodeType("OP_DIV");
		
		static public const OP_POW				:NodeType = new NodeType("OP_POW");
		
		static public const OP_GREATER			:NodeType = new NodeType("OP_GREATER");
		static public const OP_GREATER_EQUAL	:NodeType = new NodeType("OP_GREATER_EQUAL");
		
		static public const OP_LESS				:NodeType = new NodeType("OP_LESS");
		static public const OP_LESS_EQUAL		:NodeType = new NodeType("OP_LESS_EQUAL");
		
		static public const OP_EQUAL			:NodeType = new NodeType("OP_EQUAL");
		static public const OP_NOT_EQUAL		:NodeType = new NodeType("OP_NOT_EQUAL");
		
		static public const OP_LOGIC_AND		:NodeType = new NodeType("OP_LOGIC_AND");
		static public const OP_LOGIC_OR			:NodeType = new NodeType("OP_LOGIC_OR");
		/** 属性访问 */
		static public const OP_DOT				:NodeType = new NodeType("OP_DOT");
		
		static public const REG_ID				:NodeType = new NodeType("REG_ID");
		static public const VAR_ID				:NodeType = new NodeType("VAR_ID");
		static public const NUM					:NodeType = new NodeType("NUM");
		static public const STRING				:NodeType = new NodeType("STRING");
		
		static public const STEMENT_BLOCK		:NodeType = new NodeType("STEMENT_BLOCK");
		static public const ARRAY				:NodeType = new NodeType("ARRAY");
		static public const OBJECT				:NodeType = new NodeType("OBJECT");
		static public const KEY_VALUE			:NodeType = new NodeType("KEY_VALUE");
		
		static public const GET_PROP			:NodeType = new NodeType("GET_PROP");
		static public const CALL_METHOD			:NodeType = new NodeType("CALL_METHOD");
		
		/** 逗号 */
		static public const COMMA				:NodeType = new NodeType("COMMA");
		/** 冒号 */
		static public const COLON				:NodeType = new NodeType("COLON");
		
		/** 小括号 */
		static public const PARENTHESES_LEFT	:NodeType = new NodeType("PARENTHESES_LEFT");
		static public const PARENTHESES_RIGHT	:NodeType = new NodeType("PARENTHESES_RIGHT");
		
		/** 中括号 */
		static public const BRACKETS_LEFT		:NodeType = new NodeType("BRACKETS_LEFT");
		static public const BRACKETS_RIGHT		:NodeType = new NodeType("BRACKETS_RIGHT");
		
		/** 大括号 */
		static public const BRACES_LEFT			:NodeType = new NodeType("BRACES_LEFT");
		static public const BRACES_RIGHT		:NodeType = new NodeType("BRACES_RIGHT");
		
		private var name:String;
		
		public function NodeType(name:String)
		{
			this.name = name;
		}
		
		public function toString():String
		{
			return name;
		}
	}
}