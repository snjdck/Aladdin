package flash.utils
{
	import string.formatInt;

	final public class DateUtil
	{
		static public function ParseTimeStamp(time:String):Date
		{
			var obj:Object = /(?P<year>\d+)-(?P<month>\d+)-(?P<date>\d+) (?P<hour>\d+):(?P<minute>\d+):(?P<second>\d+)\.(?P<millisecond>\d+)/.exec(time);
			
			if(null == obj){
				return null;
			}
			
			var year:int = obj.year;
			var month:int = obj.month - 1;
			var date:int = obj.date;
			var hour:int = obj.hour;
			var minute:int = obj.minute;
			var second:int = obj.second;
			var millisecond:int = obj.millisecond;
			
			return new Date(year, month, date, hour, minute, second, millisecond);
		}
		
		static public function GetTimeStamp(time:Number=NaN):String
		{
			var date:Date = isNaN(time) ? new Date() : new Date(time);
			return date.fullYear + "-" + (date.month+1) + "-" + date.date + " " + formatInt(date.hours) + ":" + formatInt(date.minutes) + ":" + formatInt(date.seconds);
		}
		
		static public function GetTimeInfo(time:Number=NaN):String
		{
			var date:Date = isNaN(time) ? new Date() : new Date(time);
			return formatInt(date.hours) + ":" + formatInt(date.minutes) + ":" + formatInt(date.seconds);
		}
		
		static public function sec2time(value:uint):String
		{
			var hours:uint = value / 3600;
			var minutes:uint = value % 3600 / 60;
			var seconds:uint = value % 60;
			return formatInt(hours) + ":" + formatInt(minutes) + ":" + formatInt(seconds);
		}
	}
}