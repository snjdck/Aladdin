package sorter
{
	/**
	 * Node{next,child}
	 */
	final public class LinkTreeSorter
	{
		/**
		 * @return new head
		 */
		static public function Sort(head:Object, compare:Function):*
		{
			var item:Object = head;
			while(item != null){
				item.child = Sort(item.child, compare);
				item = item.next;
			}
			return LinkListSorter.Sort(head, compare);
		}
		
		/**
		 * 
		 * director.mainloop
		 * ccobject
		 * ccnode.draw
		 * 
		 */		
		function draw(head)
		{
			var drawUnit = head;
			while(drawUnit != null){
				if(null == drawUnit.child){
					//normal draw
				}else{
					drawUnit.onEnter();
					draw(drawUnit.child);
					drawUnit.onExit();
				}
				drawUnit = drawUnit.next;
			}
		}
	}
}