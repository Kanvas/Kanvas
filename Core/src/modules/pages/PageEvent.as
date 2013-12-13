package modules.pages
{
	import flash.events.Event;
	
	public final class PageEvent extends Event
	{
		public static const ADD_PAGE:String = "addPage";
		
		public static const DELETE_PAGE:String = "deletePage";
		
		public static const DELETE_PAGE_FROM_UI:String = "deletePageFromUI";
		
		public static const UPDATE_LAYOUT:String = "updateLayout";
		
		public static const UPDATE_THUMB:String = "updateThumb";
		
		public function PageEvent(type:String, $pageVO:PageVO = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			__pageVO = $pageVO;
		}
		
		public function get pageVO():PageVO
		{
			return __pageVO;
		}
		private var __pageVO:PageVO;
	}
}