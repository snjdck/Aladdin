package flash.utils
{
	import lambda.apply;

	final public class VoUtil
	{
		static public function Create(voData:Object, wrapper:Object):*
		{
			var vo:Object = lambda.apply(wrapper);
			for(var key:Object in voData){
				SetProp(vo, key, voData[key]);
			}
			return vo;
		}
		
		static private function SetProp(target:Object, key:Object, value:Object):void
		{
			try{
				target[key] = value;
			}catch(error:Error){
				if(1034 == error.errorID){
					var regExp:RegExp = (value is Array) ? (/(__AS3__\.vec\.Vector\.<([$.\w]+)>)/) : (/\s([$.\w]+).$/);
					var result:Array = regExp.exec(error.message);
					if(null != result){
						SetProp(target, key, Create(value, result[1]));
						return;
					}
				}
				throw error;
			}
		}
	}
}