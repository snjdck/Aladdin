package d3d
{
	import snjdck.g3d.core.Object3D;

	public function removeAllChildren(target:Object3D):void
	{
		if(null == target){
			return;
		}
		while(target.firstChild){
			target.removeChild(target.firstChild);
		}
	}
}