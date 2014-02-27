package flash.utils
{
	final public class DictUtil
	{
		/**
		 * @return output
		 */
		static public function ReMap(target:Object, context:Object, output:Object):*
		{
			for(var key:* in target){
				output[key] = context[target[key]];
			}
			return output;
		}
	}
}