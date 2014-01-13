package d3d
{
	import snjdck.g3d.core.Object3D;

	public function traverse(target:Object3D, handler:Function):void
	{
		handler(target);
		for(var child:Object3D=target.firstChild; child != null; child=child.nextSibling){
			traverse(child, handler);
		}
	}
}