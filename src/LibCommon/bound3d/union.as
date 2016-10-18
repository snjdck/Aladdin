package bound3d
{
	import snjdck.g3d.bounds.AABB;

	public function union(a:AABB, b:AABB, result:AABB):void
	{
		if(a.isEmpty()){
			if(result != b){
				result.copyFrom(b);
			}
			return;
		}
		if(b.isEmpty()){
			if(result != a){
				result.copyFrom(a);
			}
			return;
		}
		var minX:Number = Math.min(a.minX, b.minX);
		var minY:Number = Math.min(a.minY, b.minY);
		var minZ:Number = Math.min(a.minZ, b.minZ);
		var maxX:Number = Math.max(a.maxX, b.maxX);
		var maxY:Number = Math.max(a.maxY, b.maxY);
		var maxZ:Number = Math.max(a.maxZ, b.maxZ);
		result.setMinMax(minX, minY, minZ, maxX, maxY, maxZ);
	}
}