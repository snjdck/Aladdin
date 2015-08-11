package
{
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.obj3d.Line3D;
	import snjdck.gpu.View3D;
	
	public class LineTest extends Sprite
	{
		private var view:View3D;
		
		public function LineTest()
		{
			view = new View3D(stage);
			view.enableErrorChecking = true;
			var line:Line3D = new Line3D();
			line.setPt(new Vector3D(), new Vector3D(100,0,0));
			line.color.rgb = 0xFF0000;
			view.scene3d.root.addChild(line);
			line = new Line3D();
			line.setPt(new Vector3D(), new Vector3D(0,100,0));
			line.color.rgb = 0xFF00;
			view.scene3d.root.addChild(line);
			line = new Line3D();
			line.setPt(new Vector3D(), new Vector3D(0,0,100));
			line.color.rgb = 0xFF;
			view.scene3d.root.addChild(line);
		}
	}
}