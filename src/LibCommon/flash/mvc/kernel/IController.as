package flash.mvc.kernel
{
	import flash.mvc.notification.MsgName;

	public interface IController
	{
		function regCmd(msgName:MsgName, cmdCls:Class):void;
		function delCmd(msgName:MsgName, cmdCls:Class):void;
		function hasCmd(msgName:MsgName, cmdCls:Class):Boolean;
		function execCmd(cmdCls:Class):void;
	}
}