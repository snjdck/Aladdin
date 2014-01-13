package d3d
{
	import snjdck.g3d.core.Object3D;

	public function removeChildByName(target:Object3D, childName:String):void
	{
		if(target){
			target.removeChild(target.getChild(childName));
		}
	}
}