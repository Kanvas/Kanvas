package modules.pages
{
	import commands.Command;
	
	import flash.events.EventDispatcher;
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
			pg_internal::pages = new Vector.<PageVO>;
		}
		
		/**
		 * 根据画布当前布局获取pageVO
		 */
		public function addPageFromUI():void
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
			
			coreMdt.createNewShapeMouseUped = true;
			coreMdt.sendNotification(Command.CREATE_PAGE, proxy);
		}
		
		/**
		 * 添加页
		 */
		public function addPage(pageVO:PageVO):PageVO
		{
			registPageVO(pageVO, pages.length);
			pages.push(pageVO);
			
			dispatchEvent(new PageEvent(PageEvent.PAGE_ADDED, pageVO));
			dispatchEvent(new PageEvent(PageEvent.UPDATE_PAGES_LAYOUT));
			
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
					dispatchEvent(new PageEvent(PageEvent.PAGE_ADDED, pageVO));
				}
				else
				{
					if (index < pages.length)
					{
						setPageIndex(pageVO, index);
						dispatchEvent(new PageEvent(PageEvent.PAGE_ADDED, pageVO));
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
				
				dispatchEvent(new PageEvent(PageEvent.PAGE_DELETED, pageVO));
				dispatchEvent(new PageEvent(PageEvent.UPDATE_PAGES_LAYOUT));
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
			if (index >= 0 && index < pages.length)
			{
				var pageVO:PageVO = pages[index];
				removePageVO(pageVO);
				pages.splice(index, 1);
				
				dispatchEvent(new PageEvent(PageEvent.PAGE_DELETED, pageVO));
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
			if (index >= 0 && index < pages.length)
			{
				var cur:int = pages.indexOf(pageVO);
				if (cur != -1)
				{
					var aim:int = (index > cur) ? index - 1 : index;
					pages.splice(cur, 1);
					pages.splice(aim, 0, pageVO);
					var min:int = Math.min(cur, aim);
					var max:int = Math.max(cur, aim);
					for (var i:int = min; i < max; i++)
						pages[i].index = i;
					
					dispatchEvent(new PageEvent(PageEvent.UPDATE_PAGES_LAYOUT));
				}
				else
				{
					throw new ArgumentError("提供的 PageVO 必须是调用者的子级。", 2025);
				}
			}
			else
			{
				throw new RangeError("提供的索引超出范围。", 2006);
			}
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
			pageVO.pg_internal::index = - 1;
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