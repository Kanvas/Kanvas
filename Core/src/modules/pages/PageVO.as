package modules.pages
{
	import flash.display.BitmapData;
	
	import model.vo.ElementVO;
	
	import modules.pages.pg_internal;
	
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
		
		override public function set x(value:Number):void
		{
			if (x != value)
			{
				super.x = value;
				dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set y(value:Number):void
		{
			if (y != value)
			{
				super.y = value;
				dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set width(value:Number):void
		{
			if (width != value)
			{
				super.width = value;
				dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set height(value:Number):void
		{
			if (height != value)
			{
				super.height = value;
				dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set scale(value:Number):void
		{
			if (scale != value)
			{
				super.scale = value;
				dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set rotation(value:Number):void
		{
			if (rotation != value)
			{
				super.rotation = value;
				dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
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
		public var bitmapData:BitmapData;
	}
}