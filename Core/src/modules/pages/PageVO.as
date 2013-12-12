package modules.pages
{
	import model.vo.ElementVO;
	import modules.pages.pg_internal;
	
	[Event(name="updateThumb", type="modules.pages.PageEvent")]
	
	public final class PageVO extends ElementVO
	{
		public function PageVO()
		{
			super();
		}
		
		
		
		public function get parent():PageManager
		{
			return pg_internal::parent;
		}
		pg_internal var parent:PageManager
		
		
		
		public function get index():int
		{
			return pg_internal::index;
		}
		public function set index(value:int):void
		{
			pg_internal::index = value;
		}
		pg_internal var index:int = -1;
		
		
	}
}