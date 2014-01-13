package snjdck.mvc.core
{
	import snjdck.mvc.MsgName;

	public interface IController
	{
		function regCmd(msgName:MsgName, cmdCls:Class):void;
		function delCmd(msgName:MsgName, cmdCls:Class):void;
		function hasCmd(msgName:MsgName, cmdCls:Class):Boolean;
	}
}