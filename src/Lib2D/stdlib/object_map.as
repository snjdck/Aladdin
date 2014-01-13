package stdlib
{
	/**
	 * @return output
	 */
	public function object_map(target:Object, context:Object, output:Object):*
	{
		for(var key:* in target){
			output[key] = context[target[key]];
		}
		return output;
	}
}