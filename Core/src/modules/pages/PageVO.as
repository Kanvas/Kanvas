package modules.pages
{
	import model.vo.ElementVO;
	
	public final class PageVO extends ElementVO
	{
		public function PageVO()
		{
			super();
		}
		
		public function get index():int
		{
			return __index;
		}
		public function set index(value:int):void
		{
			__index = value;
		}
		private var __index:int;
	}
}