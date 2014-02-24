package modules.pages
{
	import commands.Command;
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import model.ElementProxy;
	
	import view.interact.CoreMediator;

	[Event(name="pageAdded", type="modules.pages.PageEvent")]
	
	[Event(name="pageDeleted", type="modules.pages.PageEvent")]
	
	[Event(name="updatePagesLayout", type="modules.pages.PageEvent")]
	
	/**
	 * 负责页面的创建，编辑，删除等
	 */	
	public final class PageManager extends EventDispatcher
	{
		
		public function PageManager($coreMdt:CoreMediator)
		{
			coreMdt = $coreMdt;
			pageQuene = new PageQuene;
			pageQuene.addEventListener(PageEvent.PAGE_ADDED, defaultHandler);
			pageQuene.addEventListener(PageEvent.PAGE_DELETED, defaultHandler);
			pageQuene.addEventListener(PageEvent.UPDATE_PAGES_LAYOUT, defaultHandler);
		}
		
		/**
		 * 根据画布当前布局获取pageVO
		 */
		public function addPageFromUI(index:int = 0):void
		{
			var bound:Rectangle = coreMdt.mainUI.bound;
			var proxy:ElementProxy = new ElementProxy;
			
			proxy.x = (bound.left + bound.right) * .5;
			proxy.y = (bound.top + bound.bottom) * .5;
			proxy.rotation = - coreMdt.canvas.rotation;
			proxy.width = bound.width ;
			proxy.height = bound.height;
			proxy.index = (index > 0 && index < numPage) ? index : numPage;
			proxy.ifSelectedAfterCreate = false;
			
			coreMdt.createNewShapeMouseUped = true;
			coreMdt.sendNotification(Command.CREATE_PAGE, proxy);
		}
		
		/**
		 * 添加页
		 */
		public function addPage(pageVO:PageVO):PageVO
		{
			pageQuene.addPage(pageVO);
			__currentPage = pageVO.index;
			return pageVO;
		}
		
		/**
		 * 在指定位置添加页，index超出范围时自动加到最后一页
		 */
		public function addPageAt(pageVO:PageVO, index:int):PageVO
		{
			pageQuene.addPageAt(pageVO, index);
			__currentPage = pageVO.index;
			return pageVO;
		}
		
		/**
		 * 判断pageVO是否在队列
		 */
		public function contains(pageVO:PageVO):Boolean
		{
			return pageQuene.contains(pageVO);
		}
		
		/**
		 * 获取序号为index的pageVO
		 */
		public function getPageAt(index:int):PageVO
		{
			return pageQuene.getPageAt(index);
		}
		
		/**
		 * 获取pageVO的序号
		 */
		public function getPageIndex(pageVO:PageVO):int
		{
			return pageQuene.getPageIndex(pageVO);
		}
		
		/**
		 * 从队列中删除页
		 */
		public function removePage(pageVO:PageVO):PageVO
		{
			if (currentPage == pageVO.index) __currentPage = 0;
			return pageQuene.removePage(pageVO);
		}
		
		/**
		 * 从队列中删除序号为index的页
		 */
		public function removePageAt(index:int):PageVO
		{
			return pageQuene.removePageAt(index);
		}
		
		/**
		 * 设定某页的顺序
		 */
		public function setPageIndex(pageVO:PageVO, index:int, sendEvent:Boolean = false):void
		{
			pageQuene.setPageIndex(pageVO, index, sendEvent);
		}
		
		public function viewPage(page:int):void
		{
			__currentPage = page;
			var scene:Scene = PageUtil.getSceneFromVO(pages[page], coreMdt.mainUI);
			coreMdt.zoomMoveControl.zoomRotateMoveTo(scene.scale, scene.rotation, scene.x, scene.y);
		}
		
		public function resetView():void
		{
			__currentPage = 0;
		}
		
		private function defaultHandler(e:PageEvent):void
		{
			dispatchEvent(e);
		}
		
		public function get currentPage():int
		{
			return __currentPage;
		}
		private var __currentPage:int = 0;
		
		/**
		 * 获取总页数
		 */
		public function get numPage():int
		{
			return pageQuene.numPage;
		}
		
		/**
		 * 获取pageVO集合
		 */
		public function get pages():Vector.<PageVO>
		{
			return pageQuene.pages;
		}
		
		private var pageQuene:PageQuene;
		
		private var coreMdt:CoreMediator;
	}
}