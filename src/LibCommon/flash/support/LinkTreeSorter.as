package flash.support
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
	}
}