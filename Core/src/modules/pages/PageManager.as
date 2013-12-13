package modules.pages
{
	import commands.Command;
	
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	import model.ElementProxy;
	
	import util.StyleUtil;
	
	import view.interact.CoreMediator;

	[Event(name="addPage", type="modules.pages.PageEvent")]
	
	[Event(name="deletePage", type="modules.pages.PageEvent")]
	
	[Event(name="updateLayout", type="modules.pages.PageEvent")]
	
	public final class PageManager extends EventDispatcher
	{
		
		public function PageManager($coreMdt:CoreMediator)
		{
			coreMdt = $coreMdt;
			pg_internal::pages = new Vector.<PageVO>;
		}
		
		/**
		 * 根据画布当前布局获取pageVO
		 */
		public function addPageFromCanvas():void
		{
			var bound:Rectangle = coreMdt.mainUI.bound;
			var proxy:ElementProxy = new ElementProxy;
			proxy.type = "page";
			proxy.styleType = "border";
			proxy.styleID = "Page";
			proxy.x = (bound.left + bound.right) * .5;
			proxy.y = (bound.top + bound.bottom) * .5;
			proxy.width = bound.width ;
			proxy.height = bound.height;
			coreMdt.sendNotification(Command.CREATE_SHAPE, proxy);
			
		}
		
		/**
		 * 添加页
		 */
		public function addPage(pageVO:PageVO):PageVO
		{
			registPageVO(pageVO, pages.length);
			pages.push(pageVO);
			dispatchEvent(new PageEvent(PageEvent.ADD_PAGE, pageVO));
			return pageVO;
		}
		
		/**
		 * 在指定位置添加页，index超出范围时自动加到最后一页
		 */
		public function addPageAt(pageVO:PageVO, index:int):PageVO
		{
			if (index >=0 && index <= pages.length)
			{
				if (pageVO.parent != this)
				{
					registPageVO(pageVO, index);
					pages.splice(index, 0, pageVO);
					dispatchEvent(new PageEvent(PageEvent.ADD_PAGE, pageVO));
				}
				else
				{
					if (index < pages.length)
					{
						setPageIndex(pageVO, index);
						dispatchEvent(new PageEvent(PageEvent.ADD_PAGE, pageVO));
					}
					else
					{
						throw new RangeError("提供的索引超出范围。", 2006);
					}
				}
			}
			else
			{
				throw new RangeError("提供的索引超出范围。", 2006);
			}
			return pageVO;
		}
		
		/**
		 * 判断pageVO是否在队列
		 */
		public function contains(pageVO:PageVO):Boolean
		{
			return pageVO.parent == this;
		}
		
		/**
		 * 获取序号为index的pageVO
		 */
		public function getPageAt(index:int):PageVO
		{
			var pageVO:PageVO;
			if (index >=0 && index < pages.length)
				pageVO = pages[index];
			else
				throw new RangeError("提供的索引超出范围。", 2006);
			return pageVO;
		}
		
		/**
		 * 获取pageVO的序号
		 */
		public function getPageIndex(pageVO:PageVO):int
		{
			if (contains(pageVO))
				var index:int = pages.indexOf(pageVO);
			else
				throw new ArgumentError("提供的 PageVO 必须是调用者的子级。", 2025);
			return index;
		}
		
		/**
		 * 从队列中删除页
		 */
		public function removePage(pageVO:PageVO):PageVO
		{
			if (contains(pageVO))
			{
				var index:int = pages.indexOf(pageVO);
				removePageVO(pageVO);
				pages.splice(index, 1);
				dispatchEvent(new PageEvent(PageEvent.DELETE_PAGE, pageVO));
			}
			else
			{
				throw new ArgumentError("提供的 PageVO 必须是调用者的子级。", 2025);
			}
			return pageVO;
		}
		
		/**
		 * 从队列中删除序号为index的页
		 */
		public function removePageAt(index:int):PageVO
		{
			if (index >=0 && index < pages.length)
			{
				removePageVO(pages[index]);
				pages.splice(index, 1);
				dispatchEvent(new PageEvent(PageEvent.DELETE_PAGE, pages[index]));
			}
			else
			{
				throw new RangeError("提供的索引超出范围。", 2006);
			}
			return null;
		}
		
		/**
		 * 设定某页的顺序
		 */
		public function setPageIndex(pageVO:PageVO, index:int):void
		{
			
		}
		
		
		/**
		 * 加入pageVO时，设定VO的index与parent
		 */
		private function registPageVO(pageVO:PageVO, index:int):void
		{
			pageVO.pg_internal::index = index;
			pageVO.pg_internal::parent = this;
		}
		
		/**
		 * 删除pageVO时，对VO的初始化
		 */
		private function removePageVO(pageVO:PageVO):void
		{
			pageVO.pg_internal::index = -1;
			pageVO.pg_internal::parent = null;
		}
		
		
		/**
		 * 获取总页数
		 */
		public function get numPage():int
		{
			return pages.length;
		}
		
		/**
		 * 获取pageVO集合
		 */
		public function get pages():Vector.<PageVO>
		{
			return pg_internal::pages;
		}
		
		
		/**
		 * 当前页
		 */
		public function get index():int
		{
			return __index;
		}
		public function set index(value:int):void
		{
			__index = value;
		}
		private var __index:int;
		
		pg_internal var pages:Vector.<PageVO>;
		
		private var coreMdt:CoreMediator;
	}
}