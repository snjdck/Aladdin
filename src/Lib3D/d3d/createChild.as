package d3d
{
	import snjdck.g3d.core.Object3D;

	public function createChild(parent:Object3D, childName:String=null, childTypeName:String=null):Object3D
	{
		var child:Object3D = new Object3D(childName, childTypeName);
		parent.addChild(child);
		return child;
	}
}