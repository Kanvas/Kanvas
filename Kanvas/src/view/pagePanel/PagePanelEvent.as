package view.pagePanel
{
	import flash.events.Event;
	
	/**
	 */	
	public class PagePanelEvent extends Event
	{
		
		/**
		 * 开始拖动列表中的页面
		 */		
		public static const START_DRAG_PAGE:String = 'startDragPage';
		
		
		/**
		 * 停止拖动列表中的页面
		 */		
		public static const END_DRAG_PAGE:String = 'endDragPage';
		
		
		/**
		 * 正在拖动列表中的页面
		 */		
		public static const PAGE_DRAGGING:String = 'pageDragging';
		
		/**
		 */		
		public function PagePanelEvent(type:String, pageUI:PageUI)
		{
			super(type, true);
			
			this.pageUI = pageUI;
		}
		
		public var pageUI:PageUI;
	}
}