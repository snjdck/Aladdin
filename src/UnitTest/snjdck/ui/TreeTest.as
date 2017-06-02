package snjdck.ui
{
//	import com.shaokai.controls.Tree;
	
	import flash.display.Sprite;
	
	import snjdck.ui.tree.Tree;
	
	public class TreeTest extends Sprite
	{
		public function TreeTest()
		{
			var tree:Tree = new Tree();
			addChild(tree);
			
//			tree.width = 200;
//			tree.height = 300;
			tree.dataProvider = <xml>
	<a label="1">
		<item label="1-1" />
		<a label="1-2">
			<item label="1-2-1" />
		</a>
		<b label="1-3">
			<item label="1-3-1" />
		</b>
		<a label="1-4">
			<item label="1-4-1" />
		</a>
		<b label="1-5">
			<item label="1-5-1" />
		</b>
	</a>
	<b label="2">
		<item label="2-1" />
		<a label="2-2">
			<item label="2-2-1" />
		</a>
		<b label="2-3">
			<item label="2-3-1" />
		</b>
		<a label="2-4">
			<item label="2-4-1" />
		</a>
		<b label="2-5">
			<item label="2-5-1" />
			<a label="2-5-2">
				<item label="2-5-2-1" />
			</a>
			<b label="2-5-3">
				<item label="2-5-3-1" />
				<a label="2-5-3-2">
					<item label="2-5-3-2-1" />
				</a>
				<b label="2-5-3-3">
					<item label="2-5-3-3-1" />
				</b>
			</b>
		</b>
	</b>
</xml>;
			//tree.dataProvider = <xml><a label="test" /></xml>
		}
	}
}