package snjdck.agalc.arithmetic.rule
{
	import snjdck.agalc.arithmetic.node.NodeType;

	final public class LexRuleFactory
	{
		static public function CreateShaderArithmeticRuleList():ILexRule
		{
			var ruleList:LexRuleList = new LexRuleList();
			
			ruleList.addRule(/([a-z]\w{2}):/, NodeType.VAR_ID);
			ruleList.addRule(/fs\d{1,2}<[,\w]+>/, NodeType.REG_ID);
			ruleList.addRule(/vc\[[^\]]+\](?:\.[xyzw]{1,4})?/, NodeType.REG_ID);
			ruleList.addRule(/(?:va|fs|vc|fc|vt|ft|v|op|oc|od)\d{0,3}(?:\.[xyzw]{1,4})?/, NodeType.REG_ID);
			ruleList.addRule(/0|[1-9]\d*/, NodeType.NUM);
			
			ruleList.addRule(/==/, NodeType.OP_EQUAL);
			ruleList.addRule(/!=/, NodeType.OP_NOT_EQUAL);
			
			ruleList.addRule(/>=/, NodeType.OP_GREATER_EQUAL);
			ruleList.addRule(/>/, NodeType.OP_GREATER);
			ruleList.addRule(/<=/, NodeType.OP_LESS_EQUAL);
			ruleList.addRule(/</, NodeType.OP_LESS);
			
			ruleList.addRule(/[+\-*/^]?=/, NodeType.OP_ASSIGN);
			
			ruleList.addRule(/\+/, NodeType.OP_ADD);
			ruleList.addRule(/-/, NodeType.OP_SUB);
			ruleList.addRule(/\*/, NodeType.OP_MUL);
			ruleList.addRule(/\//, NodeType.OP_DIV);
			ruleList.addRule(/\^/, NodeType.OP_POW);
			
			ruleList.addRule(/\(/, NodeType.PARENTHESES_LEFT);
			ruleList.addRule(/\)/, NodeType.PARENTHESES_RIGHT);
			//加减,乘除,正负,指数
			ruleList.addRule(/,/, NodeType.COMMA);
			ruleList.addRule(/:/, NodeType.COLON);
			
			return ruleList;
		}
		
		static public function CreateScriptArithmeticRuleList():ILexRule
		{
			var ruleList:LexRuleList = new LexRuleList();
			
			ruleList.addRule(/\bif\b/, NodeType.KEYWORD_IF);
			ruleList.addRule(/\bwhile\b/, NodeType.KEYWORD_WHILE);
			ruleList.addRule(/\bvar\b/, NodeType.KEYWORD_VAR);
			ruleList.addRule(/\bfunc\b/, NodeType.KEYWORD_FUNC);
			ruleList.addRule(/\breturn\b/, NodeType.KEYWORD_RETURN);
			
			ruleList.addRule(/[$_a-zA-Z][$_a-zA-Z0-9]*/, NodeType.VAR_ID);
			ruleList.addRule(/(0|[1-9]\d*)(\.\d+)?/, NodeType.NUM);
			ruleList.addRule(/".*?"/, NodeType.STRING);
			ruleList.addRule(/\./, NodeType.OP_DOT);
			ruleList.addRule(/,/, NodeType.COMMA);
			ruleList.addRule(/:/, NodeType.COLON);
			
			ruleList.addRule(/&&/, NodeType.OP_LOGIC_AND);
			ruleList.addRule(/\|\|/, NodeType.OP_LOGIC_OR);
			
			ruleList.addRule(/==/, NodeType.OP_EQUAL);
			ruleList.addRule(/!=/, NodeType.OP_NOT_EQUAL);
			
			ruleList.addRule(/>=/, NodeType.OP_GREATER_EQUAL);
			ruleList.addRule(/>/, NodeType.OP_GREATER);
			ruleList.addRule(/<=/, NodeType.OP_LESS_EQUAL);
			ruleList.addRule(/</, NodeType.OP_LESS);
			
			ruleList.addRule(/\+/, NodeType.OP_ADD);
			ruleList.addRule(/-/, NodeType.OP_SUB);
			ruleList.addRule(/\*/, NodeType.OP_MUL);
			ruleList.addRule(/\//, NodeType.OP_DIV);
			ruleList.addRule(/\^/, NodeType.OP_POW);
			
			ruleList.addRule(/=/, NodeType.OP_ASSIGN);
			
			ruleList.addRule(/\(/, NodeType.PARENTHESES_LEFT);
			ruleList.addRule(/\)/, NodeType.PARENTHESES_RIGHT);
			
			ruleList.addRule(/\[/, NodeType.BRACKETS_LEFT);
			ruleList.addRule(/\]/, NodeType.BRACKETS_RIGHT);
			
			ruleList.addRule(/\{/, NodeType.BRACES_LEFT);
			ruleList.addRule(/\}/, NodeType.BRACES_RIGHT);
			//加减,乘除,正负,指数
			
			return ruleList;
		}
	}
}