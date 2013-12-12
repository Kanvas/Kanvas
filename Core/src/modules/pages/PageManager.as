package modules.pages
{
	public final class PageManager
	{
		public function PageManager()
		{
		}
		
		/**
		 * 添加页，参数为空时自动以当前画布场景设定pageVO
		 */
		public function addPage(pageVO:PageVO = null):PageVO
		{
			return null;
		}
		
		/**
		 * 在指定位置添加页，index超出范围时自动加到最后一页
		 */
		public function addPageAt(pageVO:PageVO = null, index:int = -1):PageVO
		{
			return null;
		}
		
		/**
		 * 判断pageVO是否在队列
		 */
		public function contains(pageVO:PageVO):Boolean
		{
			return false;
		}
		
		/**
		 * 获取序号为index的pageVO
		 */
		public function getPageAt(index:int):PageVO
		{
			return null;
		}
		
		/**
		 * 获取pageVO的序号
		 */
		public function getPageIndex(pageVO:PageVO):int
		{
			return -1;
		}
		
		/**
		 * 从队列中删除页
		 */
		public function removePage(pageVO:PageVO):PageVO
		{
			return null;
		}
		
		/**
		 * 从队列中删除序号为index的页
		 */
		public function removePageAt(index:int):PageVO
		{
			return null;
		}
		
		/**
		 * 设定某页的顺序
		 */
		public function setPageIndex(pageVO:PageVO, index:int):void
		{
			
		}
		
		
		/**
		 * 获取总页数
		 */
		public function get numPage():int
		{
			return 0;
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
		
		private var pages:Vector.<PageVO>;
	}
}