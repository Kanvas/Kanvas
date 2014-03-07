package modules.pages
{
	import commands.Command;
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import model.ElementProxy;
	
	import view.interact.CoreMediator;
	import model.vo.PageVO;

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
			proxy.index = (index > 0 && index < length) ? index : length;
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
			__index = pageVO.index;
			return pageVO;
		}
		
		/**
		 * 在指定位置添加页，index超出范围时自动加到最后一页
		 */
		public function addPageAt(pageVO:PageVO, index:int):PageVO
		{
			pageQuene.addPageAt(pageVO, index);
			__index = pageVO.index;
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
			if (index == pageVO.index) __index = -1;
			return pageQuene.removePage(pageVO);
		}
		
		/**
		 * 从队列中删除序号为index的页
		 */
		public function removePageAt(index:int):PageVO
		{
			return pageQuene.removePageAt(index);
		}
		
		public function removeAllPages():void
		{
			pageQuene.removeAllPages();
			__index = -1;
		}
		
		/**
		 * 设定某页的顺序
		 */
		public function setPageIndex(pageVO:PageVO, index:int, sendEvent:Boolean = false):void
		{
			pageQuene.setPageIndex(pageVO, index, sendEvent);
		}
		
		public function next():void
		{
			index = (index + 1 >= pageQuene.length) ? -1 : index + 1;
		}
		
		public function prev():void
		{
			index = (index - 1 < -1) ? pageQuene.length - 1 : index - 1;
		}
		
		public function reset():void
		{
			__index = -1;
		}
		
		private function defaultHandler(e:PageEvent):void
		{
			dispatchEvent(e);
		}
		
		
		public function get index():int
		{
			return __index;
		}
		public function set index(value:int):void
		{
			if (value >= -1 && value < pageQuene.length)
			{
				__index = value;
				if (index >= 0)
				{
					var scene:Scene = PageUtil.getSceneFromVO(pageQuene.pages[index], coreMdt.mainUI);
					coreMdt.zoomMoveControl.zoomRotateMoveTo(scene.scale, scene.rotation, scene.x, scene.y);
				}
				else
				{
					coreMdt.zoomMoveControl.autoZoom();
				}
			}
			
		}
		
		private var __index:int = -1;
		
		/**
		 * 获取总页数
		 */
		public function get length():int
		{
			return pageQuene.length;
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