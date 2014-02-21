package modules.pages
{
	import model.vo.ElementVO;
	
	import modules.pages.pg_internal;
	
	import spark.supportClasses.INavigator;
	
	[Event(name="updateThumb", type="modules.pages.PageEvent")]
	
	[Event(name="deletePageFromUI", type="modules.pages.PageEvent")]
	
	[Event(name="pageSelected", type="modules.pages.PageEvent")]
	
	/**
	 */	
	public final class PageVO extends ElementVO
	{
		public function PageVO()
		{
			super();
		}
		
		/**
		 */		
		public function get parent():PageQuene
		{
			return pg_internal::parent;
		}
		
		pg_internal var parent:PageQuene
		
		/**
		 */		
		public function set index(value:int):void
		{
			_index = value;	
		}
		
		public function get index():int
		{
			return _index;
		}
		
		private var _index:int = -1;
		
		
	}
}