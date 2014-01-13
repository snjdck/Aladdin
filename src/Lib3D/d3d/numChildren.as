package d3d
{
	import snjdck.g3d.core.Object3D;

	public function numChildren(target:Object3D):int
	{
		var count:int = 0;
		for(var child:Object3D=target.firstChild; child != null; child=child.nextSibling){
			count++;
		}
		return count;
	}
}