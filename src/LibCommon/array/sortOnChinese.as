package array
{
	public function sortOnChinese(list:Array, field:String):void
	{
		list.sort(function(a:Object, b:Object):int{
			return collator.compare(a[field], b[field]);
		});
	}
}

import flash.globalization.Collator;
import flash.globalization.CollatorMode;

const collator:Collator = new Collator("zh-CN", CollatorMode.SORTING);