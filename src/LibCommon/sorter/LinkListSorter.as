package sorter
{
	/**
	 * Node{next}
	 */	
	final public class LinkListSorter
	{
		/**
		 * @return new head
		 */
		static public function Sort(head:Object, compare:Function):*
		{
			if(null == head){
				return null;
			}
			
			var curr:Object = head.next;
			
			head.next = null;
			while(curr != null){
				var next:Object = curr.next;
				head = Insert(head, curr, compare);
				curr = next;
			}
			
			return head;
		}
		
		/**
		 * @return new head
		 */
		static private function Insert(head:Object, item:Object, compare:Function):Object
		{
			if(compare(item, head) < 0){
				item.next = head;
				return item;
			}
			
			var prev:Object = head;
			var curr:Object = head.next;
			
			while(curr && compare(item, curr) >= 0){
				prev = curr;
				curr = curr.next;
			}
			
			item.next = prev.next;
			prev.next = item;
			
			return head;
		}
	}
}