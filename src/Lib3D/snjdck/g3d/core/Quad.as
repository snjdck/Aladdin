package snjdck.g3d.core
{
	import snjdck.g3d.obj3d.Entity;
	import snjdck.g3d.parser.Terrain;

	public class Quad extends Entity
	{
		public function Quad(name:String=null, typeName:String=null)
		{
			super(new Terrain(2, 2, 128, 128, "shaokai"));
		}
	}
}